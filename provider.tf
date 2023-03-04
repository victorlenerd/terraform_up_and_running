provider "aws" {
    region = "us-east-2"
}

resource "aws_instance" "example" {
    ami                 = "ami-0f3c9c466bb525749"
    instance_type       = "t2.micro"

    tags = {
        Name = "terraform-example"
    }
}