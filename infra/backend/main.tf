# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create an S3 bucket to store Terraform state files
resource "aws_s3_bucket" "terraform_state" {
  bucket = "devops-terraform-otel-eks-state-s3-bucket"

  # this will allow us to delete the bucket even if it contains objects
  lifecycle {
    prevent_destroy = false
  }
}

# Enable versioning on the S3 bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-eks-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}