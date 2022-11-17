pipeline {
  agent any

  environment {
     AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
     AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
  }
  
  stages {
    stage('Checkout') {
           steps {
               checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/BJWRD/cicd-terraform-aws-jenkins-pipeline']]])
            }
    }

    stage('Initialisation') {
        steps {
          script {
            echo 'Terraform Initialisation'
            sh 'terraform init'
          }
        }
    }

    stage('Validation') {
        steps {
          script {
            echo 'Terraform Validation'
            sh 'terraform validate'
            sh 'terraform fmt --recursive'
          }
        }
    }

    stage('Plan') {
      steps {
        script {
          echo 'Terraform Plan'
          sh 'terraform workspace new $environment'
          sh 'terraform workspace select $environment'
          sh 'terraform plan > tfplan.txt'
        }
      }
    }

    stage('Approval') {
      steps {
        script {
          echo 'Pushing Image...'
          input message: "Do you want to apply the plan?"
          input message: "Please read the Terraform Plan - tfplan.txt"
        }
      }
    }

    stage('Apply') {
      steps {
        script {
          echo 'Terraform Apply'
          sh 'terraform apply --auto-approve'
        }
      }
    }
  }
}