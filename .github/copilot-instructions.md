# AI Coding Agent Instructions for End-to-End DevOps Deployment

## Project Overview
This is an end-to-end DevOps deployment project that integrates multiple technologies for a complete CI/CD pipeline. The project demonstrates infrastructure as code, configuration management, containerization, and monitoring.

## Key Components

### 1. Infrastructure (Terraform)
- Located in `Terraform/VpcandEc2.tf`
- Creates AWS VPC, subnets, and EC2 instances
- Use AWS provider configuration
- Remember to handle state files appropriately

### 2. Configuration Management (Ansible)
- Playbooks in `Ansible/jenkins-playbook.yaml`
- Host configuration in `Ansible/hosts`
- Used for automated server setup and configuration

### 3. Application (Docker)
- Simple Flask application in `docker/app.py`
- Default port: 5000
- Container configuration in `docker/dockerfile`
- Application endpoint: `/wish`

### 4. Container Orchestration (Kubernetes)
- Deployment configuration in `Kuberentes/deployment.yaml`
- Uses Docker image: `525212/weekendflaskapp:1.0`
- Container port mapping: 5000

### 5. Monitoring
- Prometheus setup in `monitoring/prometheus-helm.md`
- Grafana configuration in `monitoring/grafana-helm.md`

## Development Workflow
1. Infrastructure changes should be made in Terraform first
2. Server configurations are managed through Ansible playbooks
3. Application changes follow this pipeline:
   - Code changes in `docker/app.py`
   - Docker build and push
   - Update Kubernetes deployment
   - Apply monitoring configurations

## Project Conventions
- Infrastructure definitions use Terraform HCL
- Kubernetes resources are defined in YAML
- Python Flask app follows minimal setup pattern
- Monitoring stack uses Helm charts

## Integration Points
- Jenkins CI/CD pipeline integrates with:
  - SonarQube for code quality (port 9000)
  - Docker registry for container management
  - Kubernetes for deployment
  - Prometheus/Grafana for monitoring

## Common Commands
```bash
# Infrastructure
terraform init && terraform plan && terraform apply

# Ansible
ansible-playbook -i /etc/ansible/hosts jenkins-playbook.yaml

# Kubernetes
kubectl apply -f Kuberentes/deployment.yaml
```

## Best Practices
- Always validate Terraform configurations before applying
- Use proper namespacing in Kubernetes resources
- Follow the established monitoring patterns in Grafana dashboards
- Maintain idempotency in Ansible playbooks