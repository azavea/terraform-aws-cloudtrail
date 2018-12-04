resource "aws_cloudtrail" "trail" {
  name           = "ctl${tile(var.project)}${title(var.environment)}"
  s3_bucket_name = "${var.s3_bucket_name}"

  enable_logging                = true
  include_global_service_events = true
  is_multi_region_trail         = false
  enable_log_file_validation    = false

  tags {
    Name        = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_s3_bucket" "trail" {
  count = "${var.create_s3_bucket ? 1 : 0}"

  bucket = "${var.s3_bucket_name}"
  region = "${var.region}"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "${var.s3_bucket_lifecycle_expiration}"
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

    # The AWS example policy has a more detailed path. We don't necessarily know
    # what will be in the bucket, so just apply the rule to all subdirectories
    # of the bucket..
    resources = ["${aws_s3_bucket.trail.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      value    = "bucket-owner-full-control"
    }
  }
}
