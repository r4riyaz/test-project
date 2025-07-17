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
│   └── index.html
├── Jenkinsfile
└── terraform/
    ├── main.tf
    └── variables.tf

````

## 🔧 Prerequisites

Before you begin, ensure you have the following:

- A base machine/Virtual machine for operations
- Terraform installed on your Base Machine/Virtual Machine [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform)
- VSCode Installed on your Base Machine/Virtual Machine [Install VSCode](https://code.visualstudio.com/docs/setup/linux)
- AWS account with an IAM user and access keys
- EC2 key pair (.pem file)
- AWS CLI installed & configured on your Base Machine/Virtual Machine [Install AWS CLI](https://docs.aws.amazon.com/cli/v1/userguide/install-linux.html)
- GitHub account and a repository without Readme file.
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

### ✅ 3. Configure Jenkins for Distributed Builds.

- In this section we'll configure `Jenkins-server` Instance to connect `jenkins-worker` Instance via SSH for distributed builds.
- Follow the steps Mentioned [here](https://github.com/r4riyaz/essential-jenkins/tree/main/Ch04/04_02-ssh-agent)

---

### ✅ 4. Push cloned repository to your own created repository on Github

- Run below command via Visual Studio Code otherwise you need create [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token) to authenticate with Github while pushing the code.
  
```bash 
cd devops-project
git remote -v
git remote set-url origin <URL-OF-YOUR_REPO>
git remote -v
git branch -M main
git push -u origin main
```

---

### ✅ 4. Configure Jenkins Pipeline

- Create a new pipeline project in your Jenkins server.
    - Select `New Item`
    - Enter item name (use the same name as your repo if possible)
    - Select `Pipeline` project
    - `OK`
    - Select `GitHub Project` and paste in the `<URL-OF-YOUR_REPO><URL-OF-YOUR_REPO>`
      - *NOTE: This step is optional.  It only creates a link to the repo on the project home page.*
    - Under `Build Triggers`, select the checkbox next to `GitHub hook trigger for GITScm polling`.
    - Under `Pipeline`, select `Pipeline script from SCM`.
    - Under SCM, select `Git`.
    - Under `Repository URL`, paste in the repo URL `<URL-OF-YOUR_REPO><URL-OF-YOUR_REPO>`
    - Under `Branch Specifier (blank for 'any')`, change `master` to `main`.
    - Under `Script Path` keep it as it is `Jenkinsfile`.
    - `Save` &rarr; `Build Now`.
    - *NOTE: The project must run at least one successful build before connecting to GitHub.  This allows Jenkins to read the configuration from the repo.*
    - `Jenkinsfile` is present here &rarr; [Jenkinsfile](./Jenkinsfile) and it'll be in your repository as well.

---

### ✅ 5. Connect GitHub Webhook for CI/CD

   * Copy your jenkins URL.
   * In your Github repository, Go to **Settings → Webhooks → Add Webhook**
   * Payload URL: `http://<JENKINS_PUBLIC_IP>/github-webhook/`
   * Content Type: `application/json`
   * Events: Just the push event

---

### ✅ 6. Access Your Apache Website

Visit:

```
http://<Jenkins-worker-Public-IP>:8899
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

