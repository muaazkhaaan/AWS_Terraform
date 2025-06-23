resource "aws_s3_bucket" "muaaz_s3buck" {
  bucket = "muaaz-tf-example-bucket"
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.muaaz_s3buck.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.muaaz_s3buck.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "example" {
    bucket = aws_s3_bucket.muaaz_s3buck.id

    index_document {
        suffix = "index.html"
    }

    error_document {
        key = "error.html"
    }
}