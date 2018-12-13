variable "project" {
  default     = "Unknown"
  description = "Project name, used for tagging and naming the Trail."
}

variable "environment" {
  default     = "Unknown"
  description = "Name of the environment this Trail is targeting."
}

variable "region" {
  default     = "us-east-1"
  description = "Name of the region where the Trail should be created."
}

variable "create_s3_bucket" {
  default     = "true"
  description = "Specifies whether to create a new S3 bucket. When false, you must provide a valid bucket to 's3_bucket_name'."
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to store logs in (required)."
}

variable "s3_bucket_lifecycle_expiration" {
  default     = "90"
  description = "How many days to store logs before they will be deleted."
}

variable "enable_logging" {
  default     = "true"
  description = "Specifies whether to enable logging for the trail."
}

variable "include_global_service_events" {
  default     = "true"
  description = "Specifies whether the trail is publishing events from global services such as IAM."
}

variable "is_multi_region_trail" {
  default     = "false"
  description = "Specifies whether the trail is created in the current region or in all regions."
}

variable "enable_log_file_validation" {
  default     = "false"
  description = "Specifies whether log file integrity validation is enabled."
}

variable "is_organization_trail" {
  default     = "false"
  description = "Specifies whether the trail is an AWS Organizations trail, which must be created in the organization master account."
}

variable "s3_key_prefix" {
  default     = ""
  description = "Specifies the S3 key prefix that precedes the name of the bucket you have designated for log file delivery."
}
