module "cloudtrail_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.1.2"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
}

resource "aws_cloudtrail" "default" {
  name                          = "${module.cloudtrail_label.id}"
  enable_logging                = "${var.enable_logging}"
  s3_bucket_name                = "${var.s3_bucket_name}"
  enable_log_file_validation    = "${var.enable_log_file_validation}"
  is_multi_region_trail         = "${var.is_multi_region_trail}"
  include_global_service_events = "${var.include_global_service_events}"
  cloud_watch_logs_role_arn     = "${var.cloud_watch_logs_role_arn}"
  cloud_watch_logs_group_arn    = "${var.cloud_watch_logs_group_arn}"
  tags                          = "${module.cloudtrail_label.tags}"
  kms_key_id                    = "${var.kms_key_id}"

  event_selector {
    read_write_type           = "All"
    include_management_events = "true"

    data_resource {
      type   = "AWS::S3::Object"
      values = [ "arn:aws:s3:::"]
    }

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }
}
