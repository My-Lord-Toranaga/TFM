provider "aws" {
  region = "us-west-2"

}

variable "server_port" {
  description = "The port that the server will use for HTTP requests"
  type        = number
  default     = 8080

}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "Public_ip" {
  value       = aws_instance.example.public_ip
  description = "Public IP of web server"
}

resource "aws_instance" "example" {
  ami           = "ami-03f65b8614a860c29"
  instance_type = "t2.micro"
  tags = {
    Name = "TFM-Instance"
  }
  vpc_security_group_ids      = [aws_security_group.instance.id]
  user_data                   = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  user_data_replace_on_change = true

}
