resource "aws_instance" "jenkins_server" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name = "jenkins-server"
  }
  user_data = <<-EOF
                #script to install Jenkins server
                EOF
}
resource "aws_instance" "jenkins_worker" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name
  vpc_security_group_ids = [ aws_security_group.new-security-group.id ]

  tags = {
    Name = "jenkins-worker"
  }
  
  user_data = <<-EOF
                #script to install Jenkins client
                EOF

}

resource "aws_security_group" "new-security-group" {
  name = "allow-all-from-my-ip"
  ingress {
    description = "Allow all inbound from my IP"
    from_port = 0
    to_port = 0
    protocol = "-1"  #all protocols
    cidr_blocks = [var.my_ip]
  }

  egress {
    description = "Allow all outbound to my IP"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.my_ip]
  }
}

output "jenkins_server_ip" {
  value = aws_instance.jenkins_server.public_ip
}

output "jenkins_worker_ip" {
  value = aws_instance.jenkins_worker.public_ip
}
