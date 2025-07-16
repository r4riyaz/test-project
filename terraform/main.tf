provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "jenkins_server" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name = "jenkins-server"
  }

output "instance_ip" {
  value = aws_instance.jenkins_server.public_ip
}
