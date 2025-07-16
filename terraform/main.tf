resource "aws_instance" "jenkins_server" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name = "jenkins-server"
  }

resource "aws_instance" "jenkins_worker" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name = "jenkins-worker"
  }

output "jenkins_server_ip" {
  value = aws_instance.jenkins_server.public_ip
}

output "jenkins_worker_ip" {
  value = aws_instance.jenkins_worker.public_ip
}
