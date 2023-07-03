provider "aws" {
    region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "tf-194748"
    key= "global/s3/terraform.tfstate"
    region = "us-west-2"

    dynamodb_table = "terraform_locks"
    encrypt=true
  }
}
resource "aws_s3_bucket" "terraform_state" {
    bucket = "tf-194748"
    lifecycle {
      prevent_destroy = true
    }
    
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }  
  
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
  
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.terraform_state.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
  
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform_up_and_running_locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name ="LockID"
    type = "S"
  }
  
}