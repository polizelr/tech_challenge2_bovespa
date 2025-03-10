resource "aws_lambda_function" "trigger_glue" {
  filename         = "lambda.zip"
  function_name    = "trigger_glue_bovespa"
  role             =  var.role_arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = filebase64sha256("lambda.zip")
}

resource "aws_s3_bucket_notification" "bucket_event" {
  bucket = var.bucket_s3

  lambda_function {
    lambda_function_arn = aws_lambda_function.trigger_glue.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "raw/dados_bovespa/"
  }

  depends_on = [aws_lambda_permission.allow_s3]
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.trigger_glue.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.bucket_s3_arn
}