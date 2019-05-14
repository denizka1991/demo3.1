pipeline {
  agent {
    kubernetes {
      label 'mypod'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: some-label-value
spec:
  containers:
  - name: python3
    image: python:3
    command:
    - cat
    tty: true
  - name: terraform
    image: hashicorp/terraform
    command:
    - cat
    tty: true
"""
    }
  }

parameters {
        //string(name: 'destroy', defaultValue: 'terraform apply', description: 'terraform')
        choice(choices: ['terraform apply', 'terraform destroy'], description: 'destroy of apply?', name: 'terra')
        }

  environment {
    SVC_ACCOUNT_KEY = credentials('terraform')
    TF_VAR_password = credentials('TF_VAR_password')
    TF_VAR_api_telegram = credentials('TF_VAR_api_telegram')
    TF_VAR_MONGODB_PASSWORD = credentials('TF_VAR_MONGODB_PASSWORD')
    TF_VAR_API = credentials('TF_VAR_API')
    TF_VAR_REDIS_PASSWORD = credentials('TF_VAR_REDIS_PASSWORD')
    TF_VAR_bucket = credentials('TF_VAR_bucket')
    TF_VAR_r_pass = credentials('TF_VAR_r_pass')
    TF_VAR_jtoken = credentials('TF_VAR_jtoken')
    TF_VAR_project = credentials('TF_VAR_project')
    TF_VAR_MONGODB_ROOT_PASSWORD = credentials('TF_VAR_MONGODB_ROOT_PASSWORD')
  }

  stages {

    stage('Clone repo') {
      steps {
      checkout([$class: 'GitSCM', branches: [[name: '*/master']],
        userRemoteConfigs: [[url: 'https://github.com/Yuriy6735/demo3.1.git']]])
      }
    }
    stage("python3"){
      steps {
      container("python3"){
        sh "python3 --version"
          //sh "python unit-test.py"
        }
      }
    }


    stage('Checkout') {
      steps {
      // checkout scm
        sh 'mkdir -p creds'
        sh 'echo -n $SVC_ACCOUNT_KEY | base64 -d > ./creds/gcp-key.json'
        sh 'cat ./creds/gcp-key.json'
        sh '$TF_VAR_project = base64 -d $TF_VAR_project'
        sh 'echo $TF_VAR_project'
      }
    }


    stage("TF plan"){
      steps {
      container('terraform'){

        sh "terraform version"
        sh "terraform init"
        sh "terraform plan -out myplan"

        }
      }
    }
    stage("TF Apply") {
      steps {
        container("terraform") {
          sh "terraform apply -input=false myplan"
          sh "ls"
        }
      }
    }
  }
}