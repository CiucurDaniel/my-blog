terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.46.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "eu-central-1"
}

locals {
  bucket_name = "blog.danielciucur.com"
}

resource "aws_s3_bucket" "website_hosting_bucket" {
  bucket = local.bucket_name
}


resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.website_hosting_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}


resource "aws_s3_bucket_policy" "allow_access_to_bucket" {
  bucket = aws_s3_bucket.website_hosting_bucket.id
  policy = templatefile("policy.json", { bucket = local.bucket_name })
}


# resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
#   bucket = aws_s3_bucket.website_hosting_bucket.id
#   policy = data.aws_iam_policy_document.allow_access_from_another_account.json
# }

# data "aws_iam_policy_document" "allow_access_from_another_account" {
#   statement {
#     actions = [
#       "s3:GetObject",
#       "s3:ListBucket",
#     ]

#     resources = [
#       aws_s3_bucket.website_hosting_bucket.arn,
#       "${aws_s3_bucket.website_hosting_bucket.arn}/*",
#     ]
#   }
# }
