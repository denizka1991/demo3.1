def label = "jenkpod"
//def defaultContainer = "jnlp"


properties([parameters([choice(choices: ['terraform apply', 'terraform destroy'], description: 'apply', name: 'apply')])])

podTemplate(label: label, containers: [
  containerTemplate(name: 'python3', image: 'python:3', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'terraform', image: 'hashicorp/terraform', command: 'cat', ttyEnabled: true)
  //containerTemplate(name: 'helm', image: 'lachlanevenson/k8s-helm', command: 'cat', ttyEnabled: true)
])
{


    node(label){
        try {
                    stage('Checkout repo'){
                        checkout([$class: 'GitSCM', branches: [[name: '*/master']],
                            userRemoteConfigs: [[url: 'https://github.com/Yuriy6735/demo3.1.git']]])
                        }


                    stage('Checkout Terraform') {
                        container('terraform'){

                        //set SECRET with the credential content
                            sh 'ls -al $GOOGLE_CREDENTIALS'
                            sh 'mkdir -p creds'
                            sh "cp \$GOOGLE_CREDENTIALS ./creds/gcp-key.json"
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

                //}
            }

        catch(err){
            currentBuild.result = 'Failure'
        }
    }
}
