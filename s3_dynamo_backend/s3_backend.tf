provider "aws" {
    region = "us-east-2"
}

terraform {
    backend "s3" {
        bucket = "748201447723-terraform-up-and-running-state"
        key = "global/s3/terraform.tfstate"
        region = "us-east-2"

        dynamodb_table = "terraform-up-and-running-locks"
        encrypt = true
    }
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "748201447723-terraform-up-and-running-state"

    lifecycle {
        prevent_destroy = true
    }
}

resource "aws_s3_bucket_versioning" "terraform_state_bucket_versioning" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_bucket_server_side_encryption_configuration" {
    bucket = aws_s3_bucket.terraform_state.id
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

resource "aws_dynamodb_table" "terraform_locks" {
    name = "terraform-up-and-running-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
}

output "s3_bucket_arn" {
    value = aws_s3_bucket.terraform_state.arn
    description = "The ARN of the s3 bucket"
}

output "dynamodb_table_name" {
    value = aws_dynamodb_table.terraform_locks.name
    description = "The name of the DynamoDB table"
}