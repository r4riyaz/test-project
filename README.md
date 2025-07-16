# Devops Project


# 🚀 Apache Website Hosting with Docker, Terraform, Jenkins, and AWS

This project demonstrates a complete end-to-end DevOps pipeline to **host a static website using Apache** inside a **Docker container** deployed to **AWS EC2**, provisioned using **Terraform**, and automated using **Jenkins CI/CD**. All code is version controlled using **Git & GitHub**.

## 🧰 Technologies Used

| Tool / Tech      | Purpose                                                 |
|------------------|---------------------------------------------------------|
| **Docker**       | Containerize the Apache web server and static website   |
| **Terraform**    | Provision AWS infrastructure (EC2, security groups)     |
| **Git & GitHub** | Source code management and version control              |
| **Jenkins**      | Automate CI/CD pipeline                                 |
| **Apache**       | Web server inside Docker container                      |
| **Ubuntu**       | OS for EC2 instances                                    |
| **AWS EC2**      | Host Jenkins and Docker containers                      |


## 📁 Project Structure

```

project-root/
├── apache-web/
│   ├── Dockerfile
│   ├── index.html
│   ├── start.sh
│   └── Jenkinsfile
└── terraform/
├── main.tf
├── variables.tf
├── outputs.tf
└── terraform.tfvars

````

## 🔧 Prerequisites

Before you begin, ensure you have the following:

- AWS account with an IAM user and access keys
- EC2 key pair (.pem file)
- Docker installed locally
- Terraform installed (`>= 1.0`)
- GitHub account and repository
- Jenkins installed (on AWS EC2)
- Git installed
- Basic understanding of shell and AWS

---

## 🚀 Step-by-Step Deployment

### ✅ 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/apache-docker-site.git
cd apache-docker-site
````

---

### ✅ 2. Dockerize Apache Web Server

Navigate to `apache-web/` and create the following files:

#### 📄 `Dockerfile`

```dockerfile
FROM ubuntu:20.04

RUN apt update && apt install -y apache2
COPY index.html /var/www/html/
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80
CMD ["/start.sh"]
```

#### 📄 `start.sh`

```bash
#!/bin/bash
apachectl -D FOREGROUND
```

#### 📄 `index.html`

```html
<html>
  <head><title>Apache DevOps Site</title></head>
  <body>
    <h1>Hello from Apache in Docker on AWS!</h1>
  </body>
</html>
```

---

### ✅ 3. Set Up GitHub Repository

* Push the `apache-web/` and `terraform/` folders to your GitHub repo
* Make sure your `Jenkinsfile` is inside `apache-web/`

---

### ✅ 4. Provision AWS EC2 with Terraform

Navigate to the `terraform/` directory:

#### 📄 `main.tf`

```hcl
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

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y docker.io openjdk-11-jdk git",
      "sudo usermod -aG docker ubuntu"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}
```

#### 📄 `variables.tf`

```hcl
variable "aws_region" {}
variable "ami_id" {}
variable "key_name" {}
variable "private_key_path" {}
```

#### 📄 `terraform.tfvars`

```hcl
aws_region       = "us-east-1"
ami_id           = "ami-0c02fb55956c7d316" # Ubuntu 20.04 LTS (update if needed)
key_name         = "your-key-name"
private_key_path = "~/.ssh/your-key.pem"
```

#### 📄 `outputs.tf`

```hcl
output "instance_ip" {
  value = aws_instance.jenkins_server.public_ip
}
```

#### Run Terraform Commands

```bash
terraform init
terraform plan
terraform apply
```

---

### ✅ 5. Install Jenkins on the EC2 Instance

SSH into your provisioned EC2 instance:

```bash
ssh -i ~/.ssh/your-key.pem ubuntu@<EC2_PUBLIC_IP>
```

Install Jenkins:

```bash
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo apt-add-repository "deb https://pkg.jenkins.io/debian binary/"
sudo apt update
sudo apt install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

Open port **8080** in the EC2 Security Group and access Jenkins at:

```
http://<EC2_PUBLIC_IP>:8080
```

---

### ✅ 6. Configure Jenkins Pipeline

#### Sample `Jenkinsfile`

Place this in `apache-web/Jenkinsfile`:

```groovy
pipeline {
  agent any

  stages {
    stage('Clone Repo') {
      steps {
        git 'https://github.com/<your-username>/apache-docker-site.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        dir('apache-web') {
          sh 'docker build -t apache-web .'
        }
      }
    }

    stage('Run Apache Container') {
      steps {
        sh 'docker stop apache-web || true'
        sh 'docker rm apache-web || true'
        sh 'docker run -d -p 80:80 --name apache-web apache-web'
      }
    }
  }
}
```

---

### ✅ 7. Connect GitHub Webhook for CI/CD

1. In GitHub:

   * Go to **Settings → Webhooks → Add Webhook**
   * Payload URL: `http://<JENKINS_PUBLIC_IP>:8080/github-webhook/`
   * Content Type: `application/json`
   * Events: Just the push event

2. In Jenkins:

   * Enable `GitHub hook trigger for GITScm polling` in your pipeline job

---

### ✅ 8. Access Your Apache Website

Visit:

```
http://<EC2_PUBLIC_IP>
```

You should see your hosted static website from inside the Apache Docker container!

---

## ✅ DevOps Practices Demonstrated

| Practice                  | Tool / Technology      |
| ------------------------- | ---------------------- |
| Version Control           | Git & GitHub           |
| Infrastructure as Code    | Terraform              |
| Containerization          | Docker                 |
| CI/CD Automation          | Jenkins                |
| Web Hosting               | Apache (inside Docker) |
| Cloud Infrastructure      | AWS EC2                |
| Operating System Platform | Ubuntu                 |

---

## 🙋 Author

**Riyaz Qureshi**
GitHub: [@r4riyaz](https://github.com/r4riyaz)
