End-to-End DevOps Deployment
This guide outlines the complete end-to-end DevOps pipeline using Terraform, Ansible, Jenkins, Docker, SonarQube, Kubernetes (EKS), Prometheus, and Grafana.

📌 1. Infrastructure Setup using Terraform (AWS)
✅ Steps:
Create VPC, Subnet, Internet Gateway (IGW), and Route Table (RT)

Launch EC2 Instances inside VPC

📂 Terraform Setup:
Create a folder named terraform/

Add vpc-and-ec2.tf file

⚙️ Commands:
bash
Copy
Edit
terraform init
terraform validate
terraform plan
terraform apply
🔧 Setup Instructions:
Install Terraform on Windows or Ubuntu

Add path to environment variables

Use Git Bash or WSL/PowerShell

Install AWS CLI and configure:

bash
Copy
Edit
aws configure
📌 2. Configuration Management using Ansible
✅ Steps:
Launch a dedicated EC2 instance for Ansible

SSH into the instance and install Ansible

Update /etc/ansible/hosts with target IPs

Verify connection:

bash
Copy
Edit
ansible jenkins -m ping
📂 Folder:
Create a folder ansible/

Add:

hosts

jenkins-playbook.yaml

🛠️ Playbook Command:
bash
Copy
Edit
ansible-playbook -i /etc/ansible/hosts jenkins-playbook.yaml
📌 3. Jenkins Setup (CI/CD Pipeline)
✅ Steps:
Launch EC2 instance for Jenkins

Install Java and Jenkins

Access Jenkins at: http://<Public-IP>:8080

Setup Jenkins pipeline:

Use GitHub repo with Jenkinsfile (Groovy)

Example app: cfbook/app.py

📌 4. SonarQube Setup (Code Quality)
✅ Steps:
Install Docker on Jenkins EC2:

bash
Copy
Edit
sudo apt install docker.io
sudo docker pull sonarqube:lts-community
sudo docker run --name sonar -p 9000:9000 sonarqube:lts-community
Access SonarQube: http://<Jenkins-IP>:9000

Setup credentials (admin/admin) and change password

🧩 Jenkins Integration:
Install SonarQube Scanner plugin in Jenkins

Add SonarQube server under Manage Jenkins > System

Generate and add authentication token

Add webhook in SonarQube to point to Jenkins

📌 5. Docker Hub Integration
✅ Steps:
Create Docker Hub token

Add credentials in Jenkins:

ID: dockerdata

Username: <username>

Password/Token: <token>

📌 6. Kubernetes (EKS) Deployment
✅ Steps:
Install tools on Ubuntu instance:

eksctl

kubectl

AWS CLI

Create IAM user and configure AWS CLI

Create EKS cluster:

bash
Copy
Edit
eksctl create cluster --name <cluster-name> --region <region>
Add AWS credentials in Jenkins:

ID: eksdata

Create Kubernetes deployment.yaml file

Deploy using:

bash
Copy
Edit
kubectl apply -f deployment.yaml
🔍 Check Resources:
bash
Copy
Edit
kubectl get nodes
kubectl get pods
📌 7. Monitoring with Prometheus & Grafana
✅ Tools:
Prometheus – collects metrics

Grafana – visualizes metrics

🛠️ Setup (via Helm):
Install Helm on Ubuntu

Add Helm repo & install:

bash
Copy
Edit
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace
Get Services:

bash
Copy
Edit
kubectl get svc -n monitoring
Access Prometheus UI:

Port forward: kubectl port-forward svc/prometheus -n monitoring 9090:9090

Open: http://<public-ip>:9090

📂 File Formats
Tool	File Format
Terraform	.tf, .json
Ansible	.yaml
Jenkins	Jenkinsfile (Groovy)
Kubernetes	.yaml

📘 Notes
apt is used to install packages

nano is a command-line text editor

helm is used for deploying Kubernetes applications

Ensure permissions for key files (chmod 600 key.pem)

Always test infrastructure with:

bash
Copy
Edit
terraform validate

learbay-devops-project/
├── terraform/
│   └── vpc-and-ec2.tf
├── ansible/
│   ├── hosts
│   └── jenkins-playbook.yaml
├── jenkins/
│   └── Jenkinsfile
├── sonar/
│   └── docker-sonar-setup.sh
├── kubernetes/
│   └── deployment.yaml
├── monitoring/
│   ├── prometheus-helm.md
│   └── grafana-helm.md
├── README.md
└── .gitignore
