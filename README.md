# cicd-terraform-aws-jenkins-pipeline
This project involves the creation of a CICD Jenkins Pipeline which will be deploying a Terraform Architecture, using the following stages - Checkout, Verification, Test and Deploy.

In this project we will create:

* VPC with CIDR 10.0.0.0/16
* 3 subnets (public) with CIDR 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24
* AWS Networking (Route Table, IGW, Security Groups)
* S3 Bucket
* EC2 Instance 
* Jenkins Virtualbox Docker Container
* ```CI/CD - Terraform - AWS - Jenkins - Pipeline```


# Architecture
This architecture displays the Pipeline stages - Checkout, Build, Test, Deploy.

ENTER ARCHITECTURE IMAGE

# Prerequisites
* An AWS Account with an IAM user capable of creating resources – `AdminstratorAccess`
* A locally configured AWS profile for the above IAM user
* Terraform installation - [steps](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* AWS EC2 key pair - [steps](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
* Virtualbox installation - [steps](https://www.virtualbox.org/wiki/Downloads) 

# How to Apply/Destroy
This section details the whole end-to-end AWS infrastructure deployment. **Warning: this will create AWS resources that costs money**.

## Clone the Repo

### 1. cicd-terraform-aws-jenkins-pipeline
After setting up your Virtualbox VM and it's related network, you will want to enter the following commands to clone the cicd-terraform-aws-jenkins-pipeline repository.

    yum update -y
    yum install git -y
    cd /home
    git clone https://github.com/BJWRD/cicd-terraform-aws-jenkins-pipeline
    cd cicd-terraform-aws-jenkins-pipeline

## S3 Bucket Creation
It's best practice to store your *.tfstate* file as a secret within an S3 bucket for added security. Follow the steps below to set this up within your AWS Console. For more information visit the Terraform S3 page - [website](https://developer.hashicorp.com/terraform/language/settings/backends/s3) 

### 1. Creating the S3 Bucket
Create the S3 Bucket via the AWS CLI (ensure the S3 bucket has a unique name).
   
    aws s3 mb s3://cicd-terraform-aws-jenkins-pipeline
   
### 2. Verify the S3 Bucket Creation
   
    aws s3 ls

Enter Image 0.5

Or you should be able to view the bucket directly via the AWS Management Console within the S3 service -

Enter Image 1

### 3. File Update - backend.tf
Update the backend.tf file with your own bucket name -  `vi backend.tf`

    terraform {
	    backend "s3" {
		    bucket = "cicd-terraform-aws-jenkins-pipeline"
		    key	   = "terraform.tfstate"
		    region = "eu-west-2"
	    }
    }

### 4. Initialise the TF directory 

    terraform init

Enter Image 2

### 5. S3 Bucket Contents
After initialising you should now be able to verify the .tfstate contents within the S3 Bucket -

    aws s3api list-objects --bucket cicd-terraform-aws-jenkins-pipeline
   
Image 3

## Jenkins Installation 

### 1. `jenkins-docker-installation` GitHub Repo
To run a Jenkins Docker Container and to then perform the initial Jenkins installation setup, please access the following `jenkins-docker-installation` GitHub Repo and follow the instructions within the README.md file -

https://github.com/BJWRD/jenkins-docker-installation

## Jenkins - Terraform Plugin Setup

### 1. 

## Terraform VM Installation 

## Create a Jenkins pipeline
Within the Jenkins Dashboard select the 'New Item' option on the left-hand side, followed by 'Create a Job' -

<img width="223" alt="1 - New Item" src="https://user-images.githubusercontent.com/83971386/197384409-4d65faf6-31fb-4bfe-bb75-00ed80b97454.png">

You will then be presented with multiple items which can be created. We will need to enter an item name, followed by the Pipeline selection -

<img width="1147" alt="2 - pipeline" src="https://user-images.githubusercontent.com/83971386/197384404-194b3c1d-7942-4451-b797-1b0462e678f7.png">

Scroll down to the 'Pipeline' section and select the following Pipeline definition and copy and paste the Jenkinsfile contents within the Script field -

   Update Pipeline Config 
   
Enter Image

Click 'Save' with the 'Groovy Sandbox' tickbox selected.

NOTE: if your Jenkinsfile exists within your GitHub repo, you can also select the following SCM definition which saves you from copying and pasting the contents within the 'Pipeline Script' field -

Update Image

## Deploy Terraform Architecture using Jenkins Pipeline
Now we have a created Pipeline, we can finally select 'Build Now' to set the Pipeline build process in motion -

Update Image

Update Image 2

The Pipeline has successfully gone through the build, test, push and deployment phases and the EC2 instance should now be accessible -

Enter meaningful SSH Connectivity test

# Requirements
| Name          | Version       |
| ------------- |:-------------:|
| terraform     | ~>1.3.0     |
| aws           | ~>4.30.0      |

# Providers
| Name          | Version       |
| ------------- |:-------------:|
| aws           | ~>4.30.0      |


# List of tools/services used
* [Jenkins](https://www.jenkins.io/)
* [Terraform](https://www.terraform.io/)
* [AWS](https://aws.amazon.com/)
* [Docker](https://www.docker.com/)
* [Dockerfile](https://docs.docker.com/engine/reference/builder/)
* [Docker-Compose](https://docs.docker.com/compose/install/)
