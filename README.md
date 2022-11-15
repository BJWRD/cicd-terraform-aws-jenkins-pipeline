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

## Terraform Installation 
Before we go any further, we will need to get Terraform installed on the Virtual Machine by entering the commands below -

	 yum install yum-utils -y
	 yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
	 yum install terraform -y

## S3 Bucket Creation
It's best practice to store your *.tfstate* file as a secret within an S3 bucket for added security. Follow the steps below to set this up within your AWS Console. For more information visit the Terraform S3 page - [website](https://developer.hashicorp.com/terraform/language/settings/backends/s3) 

### 1. Creating the S3 Bucket
Create the S3 Bucket via the AWS CLI (ensure the S3 bucket has a unique name).
   
    aws s3 mb s3://cicd-terraform-aws-jenkins-pipeline
   
### 2. Verify the S3 Bucket Creation
   
    aws s3 ls

![image](https://user-images.githubusercontent.com/83971386/201901445-e532434f-db11-429a-bfb5-695ffbae13c4.png)

Or you should be able to view the bucket directly via the AWS Management Console within the S3 service -

<img width="1046" alt="image 1" src="https://user-images.githubusercontent.com/83971386/201901476-6c20ea7f-6e35-4c7d-844b-0d9f6e9dd3ef.png">

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

<img width="615" alt="image 2" src="https://user-images.githubusercontent.com/83971386/201901516-f2d8066c-9450-47d1-b6f3-8d938d955c1c.png">

### 5. S3 Bucket Contents
After initialising you should now be able to verify the .tfstate contents within the S3 Bucket -

    aws s3api list-objects --bucket cicd-terraform-aws-jenkins-pipeline
   
<img width="973" alt="image 3" src="https://user-images.githubusercontent.com/83971386/201901554-bfc930cb-a853-48c0-a22c-ad27e0dbd9f4.png">

## Jenkins Installation 
To run a Jenkins Docker Container and to then perform the initial Jenkins installation setup, please access the following `jenkins-docker-installation` GitHub Repo and follow the instructions within the README.md file -

https://github.com/BJWRD/jenkins-docker-installation

## Jenkins - Terraform Addition

### 1. Terraform Plugin Setup
To incorporate Terraform with your Jenkins instance, you will need to start by selecting the *Manage Jenkins* option to the far-left side of the Jenkins Dashboard.

<img width="228" alt="image 1" src="https://user-images.githubusercontent.com/83971386/201902227-c50f4ade-020f-479f-b5f2-5be4ef71c3a8.png">

Then select *Manage Plugins*.

<img width="911" alt="Image 2" src="https://user-images.githubusercontent.com/83971386/201902444-45b55e1f-691e-4743-bdcd-da259e85bad6.png">

Search for *Terraform* and then Install.

<img width="934" alt="image 3" src="https://user-images.githubusercontent.com/83971386/201902581-04f063d3-a781-4a5d-8083-9f859d2c0388.png">

Once restarted, you will then be able to see the *Terraform* plugin within the *Installed* area -

<img width="938" alt="Image 4" src="https://user-images.githubusercontent.com/83971386/201902835-c9c04c6f-a151-4487-a8fb-ac9a8f22b3ab.png">

### 2. Terraform Global Tool Configuration
Once again, select the *Manage Jenkins* option from the Dashboard and then click on *Global Tool Configuration*.

<img width="900" alt="image 1" src="https://user-images.githubusercontent.com/83971386/201903871-4a7c3e39-d013-4927-92e3-adfd70b609d7.png">

Scroll down to the Terraform section and select *Add Terraform*.

<img width="363" alt="Image 2" src="https://user-images.githubusercontent.com/83971386/201903997-3331791c-063a-4c14-a643-9d7be8b96a22.png">

Then enter the following information and click *Save*.

<img width="814" alt="Image 3" src="https://user-images.githubusercontent.com/83971386/201904068-e8d792fb-c3ee-41b4-a080-963b1758f3a2.png">


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
