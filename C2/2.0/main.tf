resource "aws_instance" "example" {
    ami = "ami-03f65b8614a860c29"
    instance_type   = terraform.workspace== "default"? "t3.micro" :"t3.medium"
    
}

terraform {
  backend "s3" {
    bucket = "tf-194748"
    key = "workspace-example/terrafrom.tfstate"
    region = "us-west-2"
    dynamodb_table = "terraform_up_and_running_locks"
    encrypt = true
  }
}