resource "aws_s3_bucket" "muaaz_s3buck" {
    bucket = "muaaz-tf-example-bucket"
    force_destroy = true

    tags = {
    Name = "S3 bucket",
    managed-by = "Terraform",
    deployed-by = var.deployed_by
    }
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
    acl    = "public-read"
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

resource "aws_s3_bucket_policy" "public_read_access" {
  bucket = aws_s3_bucket.muaaz_s3buck.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.muaaz_s3buck.arn}/*"
      }
    ]
  })
}

output "website_endpoint" {
  value       = aws_s3_bucket_website_configuration.example.website_endpoint
  description = "URL of the static website hosted on S3"
}
