resource "aws_glue_catalog_database" "fiap_db" {
  name = "fiap"
}

resource "aws_glue_crawler" "crawler_bovespa" {
  name          = "bovespa"
  role          = var.role_arn
  database_name = aws_glue_catalog_database.fiap_db.name

  s3_target {
    path = var.s3_location
  }

  configuration = jsonencode({
    Version = 1.0
    CrawlerOutput = {
      Partitions = { AddOrUpdateBehavior = "InheritFromTable" }
    }
  })

  tags = {
    Environment = "Tech Challenge 2"
  }
}