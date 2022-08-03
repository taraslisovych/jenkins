pipeline {
  parameters {
    string(name: "environment", defaultValue: "terraform", description: "Workspace/environment file to use for deployment")
    booleanParam(name: "AutoApprove", defaultValue: false, destination: "Automaticaly run apply after generating plan?")
  }

  environment {
    AWS_ACCESS_KEY_ID = credentials("AWS_ACCESS_KEY_ID")
    AWS_SECRET_ACCESS_KEY = credentials("AWS_SECRET_ACCESS_KEY")
  }

  agent any
  stages {
    stage('Checkout') {
        steps {
          script{
            dir("terraform")
            {
              git "https://github.com/taraslisovych/jenkins.git"
            }
          }
        }
    }
    stage('Plan') {
      steps {
        sh "pwd; cd terraform/jenkins ; terraform init -input=false"
        sh "pwd; cd terraform/jenkins ; terraform workspace new ${environment}"
        sh "pwd; cd terraform/jenkins ; terraform workspace select ${environment}"
        sh "pwd; cd terraform/jenkins ; terraform plan -input=false -out tfplan"
        sh "pwd; cd terraform/jenkins ; terraform show -no-color tfplan > tfplan.txt"
      }
    }
    stage('Approval') {
      when {
        not {
          equals expected: true, actual: params.AutoApprove
        }
      }
      steps {
        script {
          def plan = readFile "terraform/jenkins/tfplan.txt"
          input message: "Do you want to apply the plan?"
          parameters: [test (name: "Plan", description: "Please, review the plan", defaultValue: plan)]
        }
      }
    }
    stage('Apply') {
      steps {
        sh "pwd; cd terraform/jenkins ; terraform apply -input=false tfplan"
      }
    }
  }
}
