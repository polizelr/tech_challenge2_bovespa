variable "script_location" {
  default = "s3://fiap-mle-tc2/scripts/"
}

variable "default_arguments" {
  type = map(string)
  default = {
    "--job-bookmark-option"       = "job-bookmark-disable"
    "--enable-glue-datacatalog"   = "true"
  }
}