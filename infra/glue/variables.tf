variable "script_location" {
  default = "s3://fiap-mle-tc2/scripts/"
}

variable "role_arn" {
  default = "arn:aws:iam::959193658056:role/LabRole"
}

variable "default_arguments" {
  type = map(string)
  default = {
    "--job-bookmark-option"       = "job-bookmark-disable"
    "--enable-glue-datacatalog"   = "true"
  }
}