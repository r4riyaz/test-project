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

devops-project/
├── apache-web/
│   ├── Dockerfile
│   ├── index.html
│   ├── start.sh
│   └── Jenkinsfile
└── terraform/
    ├── main.tf
    └── variables.tf

````

## 🔧 Prerequisites

Before you begin, ensure you have the following:

- You need a Base machine/Virtual machine for operations
- Terraform installed on your Base Machine/Virtual Machine [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform)
- AWS account with an IAM user and access keys
- EC2 key pair (.pem file)
- AWS CLI installed & configured on your Base Machine/Virtual Machine [Install AWS CLI](https://docs.aws.amazon.com/cli/v1/userguide/install-linux.html)
- GitHub account and repository
- Git Installed locally on your Base Machine/Virtual Machine [Install Git](https://github.com/git-guides/install-git#install-git-on-linux)

---

## 🚀 Step-by-Step Deployment
---

### ✅ 1. Clone the Repository Locally

```bash
git clone https://github.com/r4riyaz/devops-project.git
cd devops-project
````

---

### ✅ 2. Provision AWS EC2 Instances with Terraform

- Navigate to the `terraform/` directory locally:
- Script Patch: [Jenkins-server](scripts/jenkins-server-automated-installation.sh) & [Jenkins-worker](scripts/jenkins-worker-automated-installation.sh)
- Paste these scripts in User_data section in `main.tf` file.

#### 📄 `main.tf`

```hcl
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
```


#### 📄 `variables.tf`

```hcl
variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  default = "ami-0f918f7e67a3323f0"
}

variable "key_name" {
  default = "k8s"
}
```

#### Run Terraform Commands

```bash
terraform init
terraform plan
terraform apply
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



https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform
