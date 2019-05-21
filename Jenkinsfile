def label = "mypod"


properties([parameters([choice(choices: ['terraform apply', 'terraform destroy'], description: 'apply', name: 'apply')])])

podTemplate(label: label, containers: [
  containerTemplate(name: 'python3', image: 'python:3', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'terraform', image: 'hashicorp/terraform', command: 'cat', ttyEnabled: true)
])
{


    node(label){
        try {
            withCredentials([file(credentialsId: 'terraform', variable: 'SVC_ACCOUNT_KEY'),
                                 string(credentialsId: 'TF_VAR_password', variable: 'TF_VAR_password'),
                                 string(credentialsId: 'TF_VAR_api_telegram', variable: 'TF_VAR_api_telegram'),
                                 string(credentialsId: 'TF_VAR_MONGODB_PASSWORD', variable: 'TF_VAR_MONGODB_PASSWORD'),
                                 string(credentialsId: 'TF_VAR_API', variable: 'TF_VAR_API'),
                                 string(credentialsId: 'TF_VAR_bucket', variable: 'TF_VAR_bucket'),
                                 string(credentialsId: 'TF_VAR_project', variable: 'TF_VAR_project'),
				 string(credentialsId: 'TF_VAR_REDIS_PASSWORD', variable: 'TF_VAR_REDIS_PASSWORD'),
				 string(credentialsId: 'TF_VAR_jtoken', variable: 'TF_VAR_jtoken'),
                                 string(credentialsId: 'TF_VAR_MONGODB_ROOT_PASSWORD', variable: 'TF_VAR_MONGODB_ROOT_PASSWORD')
                             ]) {


                    stage('Checkout repo'){
                        checkout([$class: 'GitSCM', branches: [[name: '*/master']],
                            userRemoteConfigs: [[url: 'https://github.com/denizka1991/demo3.1.git']]])
                        }


                    stage('Checkout Terraform') {
                        container('terraform'){

                        //set SECRET with the credential content
                            sh 'ls -al $SVC_ACCOUNT_KEY'
                            sh 'mkdir -p creds'
                            sh "cp \$SVC_ACCOUNT_KEY ./creds/key.json"
                         //   sh "cat creds/test.json"
                            sh 'terraform init'
                            sh 'terraform plan -out myplan'
                            //sh 'terraform apply -auto-approve -input=false myplan'
                            //sh 'terraform destroy -auto-approve -input=false'
                        }
                    }

                if (params.apply == 'terraform destroy') {
                    stage('Destroy Terraform') {
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
                        container('terraform'){
                             sh 'terraform apply -auto-approve -input=false myplan'
                             }
                        }


                    //stage('Install monitoring tools') {
                    //    container('helm'){
                    //         sh ' '
                    //         }
                    //    }
                    }

                }
            }

        catch(err){
            currentBuild.result = 'Failure'
        }
    }
}
