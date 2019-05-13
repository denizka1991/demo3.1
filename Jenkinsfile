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
  - name: python
    image: python
    command:
    - cat
    tty: true
  - name: zip
    image: kramos/alpine-zip
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

    stage("Checkout"){
      steps {
          sh 'ls -al $SVC_ACCOUNT_KEY'
          sh 'mkdir -p creds'
          sh 'echo $SVC_ACCOUNT_KEY | base64 -d > ./creds/gcp-key.json'
          sh 'cat ./creds/gcp-key.json'
          //sh 'terraform init'
          //sh 'terraform plan -out myplan'
      }
    }



    stage("Checkout Terraform"){
      steps {
      //container('terraform'){
        //set SECRET with the credential content
          //sh 'ls -al $SVC_ACCOUNT_KEY'
          //sh 'mkdir -p creds'
          //sh 'echo $SVC_ACCOUNT_KEY | base64 -d > ./creds/gcp-key.json'
          //sh 'cat ./creds/gcp-key.json'
          sh 'terraform init'
          sh 'terraform plan -out myplan'
        }
      }
    }





    stage("Run unit tests"){
      steps {
        container("python3"){
          sh "pip3 install -r ./functions/requirements.txt"
          sh "python3 --version"
          sh "python3 ./functions/app/test.py"
          sh "python3 ./functions/currentTemp/test.py"
          sh "python3 ./functions/getFromDB/test.py"
          sh "python3 ./functions/getPredictions/test.py"
          sh "python3 ./functions/saveToDB/test.py"
          sh "python3 ./functions/toZamb/test.py"
          //sh "python3 ./functions/zamb/test.py"
          }
        }
      }


    stage('Destroy Terraform') {
        steps{
            script {
                if (${params.destroy} == 'terraform destroy') {
                    stage('param'){
                        container('terraform'){
                            sh 'terraform destroy -auto-approve -input=false'
                        }
                    }

                }

                else{
                    stage("Run unit tests"){
                        container("python3"){
                            sh "pip3 install -r ./functions/requirements.txt"
                            sh "python3 --version"
                            sh "python3 ./functions/app/test.py"
                            sh "python3 ./functions/currentTemp/test.py"
                            sh "python3 ./functions/getFromDB/test.py"
                            sh "python3 ./functions/getPredictions/test.py"
                            sh "python3 ./functions/saveToDB/test.py"
                            sh "python3 ./functions/toZamb/test.py"
                            //sh "python3 ./functions/zamb/test.py"
                        }
                    }
                    stage('Apply Terraform') {
                      steps {
                        container('terraform'){
                          sh 'terraform apply -auto-approve -input=false myplan'
                        }
                      }
                    }
                }

            }
        }


    }
}
}
