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

  environment {
    SVC_ACCOUNT_KEY = credentials('terraform')
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
        sh 'ls'
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