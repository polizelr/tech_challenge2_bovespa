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

resource "aws_s3_object" "scripts_folder" {
  bucket = aws_s3_bucket.fiap_mle_tc2.bucket
  key    = "scripts/"
}

resource "aws_s3_object" "glue_script" {
  bucket = aws_s3_bucket.fiap_mle_tc2.id
  key    = "scripts/glue_bovespa.py"
  source = "${path.module}/../../scripts/glue_bovespa.py"
  etag   = filemd5("${path.module}/../../scripts/glue_bovespa.py")
}

resource "aws_s3_object" "scraping" {
  bucket = aws_s3_bucket.fiap_mle_tc2.id
  key    = "scripts/scraping.py"
  source = "${path.module}/../../scripts/scraping.py"
  etag   = filemd5("${path.module}/../../scripts/scraping.py")
}