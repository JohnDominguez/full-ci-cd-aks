pipeline {
    agent { label 'master' }
    environment {
        //be sure to replace "willbla" with your own Docker Hub username
        DOCKER_IMAGE_NAME = "jdominguez/train-schedule:latest"
    }
    stages {
        stage('Build') {
            steps {

                echo 'Running build automation'
                sh './gradlew build --no-daemon'
                archiveArtifacts artifacts: 'dist/trainSchedule.zip'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    app = docker.build(DOCKER_IMAGE_NAME)
                    app.inside {
                        sh 'echo Hello, World!'
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker_hub_login') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }

        stage('Provisión Environment Aks on Azure') {
            steps {
                checkout([
                        $class                           : 'GitSCM',
                        branches                         : [[name: "master"], [name: 'development'], [name: 'release']],
                        extensions                       : [[$class: 'CheckoutOption', timeout: 100], [$class: 'CloneOption', timeout: 100]],
                        userRemoteConfigs                : [[credentialsId: "7d87c24d-4c5b-4019-9396-6fb9e55ddb91", url: "https://johndominguez@bitbucket.org/johndominguez/terraform-aks.git"]],
                        doGenerateSubmoduleConfigurations: false
                ])
                script {
                    sh "ls"
                    sh "terraform init"
                    sh "terraform plan"
                    sh "terraform destroy -auto-approve -lock=false"
                }
            }
        }

        stage('DeployToProduction') {
            steps {
                checkout([
                        $class                           : 'GitSCM',
                        branches                         : [[name: "master"], [name: 'development'], [name: 'release']],
                        extensions                       : [[$class: 'CheckoutOption', timeout: 100], [$class: 'CloneOption', timeout: 100]],
                        userRemoteConfigs                : [[url: "https://github.com/JohnDominguez/full-ci-cd-aks.git"]],
                        doGenerateSubmoduleConfigurations: false
                ])
                script {
                    withCredentials([string(credentialsId: 'azure_password', variable: 'PASSWORD'),
                                     string(credentialsId: 'azure_user', variable: 'AZURE_URL'),
                                     string(credentialsId: 'azure_tenant_id', variable: 'TENANT_ID')]) {
                        input 'Deploy to Production?'
                        sh "az login --service-principal -u $AZURE_URL -p $PASSWORD --tenant $TENANT_ID"
                        sh "rm -rf ~/.kube/"
                        sh "az aks get-credentials --resource-group devops-rg-aks --name mas-aks-cluster"
                        sh "kubectl replace --force -f train-schedule-kube.yml"
                        sh "echo Desplegando App "
                        sh "sleep 180s"
                        sh "echo revisa la external ip de la parte inferior por el puerto 8080"
                        sh "kubectl get svc"

                    }
                }
            }
        }
    }
}
