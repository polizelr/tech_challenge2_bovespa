resource "aws_s3_bucket" "fiap_mle_tc2" {
  bucket = "fiap-mle-tc2"
}

resource "aws_s3_object" "raw_folder" {
  bucket = aws_s3_bucket.fiap_mle_tc2.bucket
  key    = "raw/"
}

resource "aws_s3_object" "refined_folder" {
  bucket = aws_s3_bucket.fiap_mle_tc2.bucket
  key    = "refined/"
}