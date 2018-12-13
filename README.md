# terraform-aws-cloudtrail

A Terraform module to create an Amazon Web Services (AWS) CloudTrail trail.

## Usage

This module creates a trail that logs to an S3 bucket. The module can be
configured to log to an existing S3 bucket, or to make a new one for you
automatically.

```hcl
module "cloudtrail" {
  source = "github.com/azavea/terraform-aws-cloudtrail?ref=develop"

  region                         = "us-east-1"
  create_s3_bucket               = true
  s3_bucket_name                 = "mysite-logs"
  s3_bucket_lifecycle_expiration = 90

  project     = "My Site"
  environment = "Production"
}
```

## Variables

- `region` - Name of the region where the trail should be created (default:
  `us-east-1`)
- `create_s3_bucket` - Whether or not to create a new S3 bucket. When `false`,
   you must provide a valid bucket to `s3_bucket_name` (default: `true`)
- `s3_bucket_name` - Name of the S3 bucket to store logs in (required)
- `s3_bucket_lifecycle_expiration` - How many days to store logs before they will be
   deleted (default: `90`)
- `enable_logging` - Specifies whether to enable logging for the trail (default: `true`)
- `include_global_service_events` - Specifies whether the trail is publishing events
  from global services such as IAM (default: `true`)
- `is_multi_region_trail` - Specifies whether the trail is created in the current region or
  in all regions (default: `false`)
- `enable_log_file_validation` - Specifies whether log file integrity validation
  is enabled (default: `false`)
- `is_organization_trail` - Specifies whether the trail is an AWS Organizations trail,
  which must be created in the organization master account (default: `false`)
- `s3_key_prefix` - Specifies the S3 key prefix that precedes the name of the bucket
   you have designated for log file delivery (Optional)
- `project` - Project name, used for tagging and naming the trail (default:
  `Unknown`)
- `environment` - Name of the environment this trail is targeting (default:
  `Unkown`)

## Outputs

- `id` - The name of the trail.
- `home_region` - The region in which the trail was created.
- `arn` - The Amazon Resource Name of the trail.
