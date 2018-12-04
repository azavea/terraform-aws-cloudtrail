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
  description = "Whether or not to create a new S3 bucket. When false, you must provide a valid bucket to 's3_bucket_name'."
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to store logs in (required)."
}

variable "s3_bucket_lifecycle_expiration" {
  default     = "90"
  description = "How many days to store logs before they will be deleted."
}
