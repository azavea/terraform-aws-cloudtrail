resource "aws_cloudtrail" "trail" {
  name           = "trail${replace(title(var.project), " ", "")}${title(var.environment)}"
  s3_bucket_name = "${var.s3_bucket_name}"
  s3_key_prefix  = "${var.s3_key_prefix}"

  enable_logging                = "${var.enable_logging}"
  include_global_service_events = "${var.include_global_service_events}"
  is_multi_region_trail         = "${var.is_multi_region_trail}"
  enable_log_file_validation    = "${var.enable_log_file_validation}"
  is_organization_trail         = "${var.is_organization_trail}"

  tags {
    Name        = "${var.project}"
    Environment = "${var.environment}"
  }

  depends_on = ["aws_s3_bucket.trail"]
}

resource "aws_s3_bucket" "trail" {
  count = "${var.create_s3_bucket ? 1 : 0}"

  bucket = "${var.s3_bucket_name}"
  region = "${var.region}"

  lifecycle_rule {
    enabled = "${var.enable_s3_bucket_transition}"

    transition {
      days          = "${var.s3_bucket_days_to_transition}"
      storage_class = "${var.s3_bucket_transition_storage_class}"
    }
  }

  lifecycle_rule {
    enabled = "${var.enable_s3_bucket_expiration}"

    expiration {
      days = "${var.s3_bucket_days_to_expiration}"
    }
  }
}

resource "aws_s3_bucket_policy" "trail" {
  count = "${var.create_s3_bucket ? 1 : 0}"

  bucket = "${aws_s3_bucket.trail.id}"
  policy = "${data.aws_iam_policy_document.cloudtrail_log_access.json}"
}

#
# Access policy for CloudTrail <> S3
# See: https://docs.aws.amazon.com/awscloudtrail/latest/userguide/create-s3-bucket-policy-for-cloudtrail.html
#
data "aws_iam_policy_document" "cloudtrail_log_access" {
  count = "${var.create_s3_bucket ? 1 : 0}"

  statement {
    sid       = "AWSCloudTrailAclCheck"
    actions   = ["s3:GetBucketAcl"]
    resources = ["${aws_s3_bucket.trail.arn}"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    sid     = "AWSCloudTrailWrite"
    actions = ["s3:PutObject"]

    resources = ["${var.s3_key_prefix != "" ? format("%s/%s/*", aws_s3_bucket.trail.arn, var.s3_key_prefix) : format("%s/*", aws_s3_bucket.trail.arn)}"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}
