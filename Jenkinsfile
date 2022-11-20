pipeline {
  agent any

  environment {
     AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
     AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
     ENVIRONMENT = 'cicd-terraform-aws-jenkins-pipeline'
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
          sh 'terraform workspace new $ENVIRONMENT'
          sh 'terraform workspace select $ENVIRONMENT'
          sh 'terraform plan > tfplan.txt'
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