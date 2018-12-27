output "id" {
  value       = "${aws_cloudtrail.trail.id}"
  description = "The name of the trail."
}

output "home_region" {
  value       = "${aws_cloudtrail.trail.home_region}"
  description = "The region in which the trail was created."
}

output "arn" {
  value       = "${aws_cloudtrail.trail.arn}"
  description = "The Amazon Resource Name of the trail."
}

output "bucket_id" {
  value       = "${element(concat(aws_s3_bucket.trail.*.id, list("")), 0)}"
  description = "The name of the log bucket, if one was created -- otherwise, an empty string."
}

output "bucket_arn" {
  value       = "${element(concat(aws_s3_bucket.trail.*.arn, list("")), 0)}"
  description = "The Amazon Resource Name of the log bucket, if one was created -- otherwise, an empty string."
}
