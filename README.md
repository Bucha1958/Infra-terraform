# 🚀 Infra-Terraform

This project automates infrastructure provisioning using **Terraform**. It is designed to create, manage, and deploy cloud resources efficiently using Infrastructure as Code (IaC).

## 🌟 Features
- ✅ Uses **Terraform** to define and manage cloud infrastructure  
- ✅ Supports **AWS/GCP** deployments  
- ✅ Modular approach for reusability (EC2, VPC, Security Groups, etc.)  
- ✅ Easily customizable and scalable  
- ✅ CI/CD integration planned  

## 🛠️ Prerequisites
Before using this project, ensure you have the following installed:

- **Terraform**: [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- **Cloud Provider CLI** (AWS/GCP)  
  - AWS CLI: [Install AWS CLI](https://aws.amazon.com/cli/)  
  - Google Cloud SDK: [Install GCloud](https://cloud.google.com/sdk/docs/install)  
- **Git** (for version control)  
- **Access credentials** for AWS or GCP (IAM User or Service Account)

## 📂 Project Structure


## 🚀 Getting Started

### 1️⃣ Clone the Repository
```sh
git clone https://github.com/Bucha1958/Infra-terraform.git
cd Infra-terraform

### 2 Initialize the Terraform
```sh
terraform init


### Plan the Infrastructure
```sh
terraform plan

### Apply the Configuration
```sh
terraform apply -auto-approve

### Destroy Resources

```sh
terraform destroy -auto-approve

