pipeline {
  parameters {
    string(name: "environment", defaultValue: "terraform", description: "Workspace/environment file to use for deployment")
    booleanParam(name: "AutoApprove", defaultValue: true, description: "Automaticaly run apply after generating plan?")
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
              git branch: "main",
              url: "https://github.com/taraslisovych/jenkins.git"
            }
          }
        }
    }
    stage('Plan') {
      steps {
        sh "pwd; terraform init -input=false"
        // sh "pwd; terraform workspace new ${environment}"
        // sh "pwd; terraform workspace select ${environment}"
        sh "pwd; terraform plan -input=false -out tfplan"
        sh "pwd; terraform show -no-color tfplan > tfplan.txt"
      }
    }
    // stage('Approval') {
    //   // when {
    //   //   not {
    //   //     equals expected: true, actual: params.AutoApprove
    //   //   }
    //   // }
    //   // steps {
    //   //   script {
    //   //     def plan = readFile "tfplan.txt"
    //   //     input message: "Do you want to apply the plan?"
    //   //     parameters: [test (name: "Plan", description: "Please, review the plan", defaultValue: plan)]
    //   //   }
    //   // }
    // }
    stage('Apply') {
      steps {
        sh "pwd; terraform apply -input=false tfplan"
      }
    }
  }
}
