resource "aws_glue_job" "bovespa_job" {
  name     = "bovespa"
  role_arn = var.role_arn

  command {
    name            = "glueetl"
    python_version  = "3"
    script_location = "${var.script_location}glue_bovespa.py"
  }

  default_arguments = var.default_arguments

  max_retries       = 0
  worker_type       = "G.1X"
  number_of_workers = 2
}