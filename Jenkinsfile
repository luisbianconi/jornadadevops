pipeline {
    agent any

    stages{

        stage ('Build Docker Image') {
            steps {
                script {
                    dockerapp = docker.build("luisbianconi/kube-news:${env.BUILD_ID}", '-f ./jornadadevops_kube-news/src/Dockerfile ./jornadadevops_kube-news/src')
                }
            }
        }

        stage ('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', '1996') {
                        dockerapp.push('latest')
                        dockerapp.push("${env.BUILD_ID}")
                    }
                }
            }
        }

        stage ('Deploy Kubernetes') {
            environment {
                tag_version = "${env.BUILD_ID}"
            }
            steps {
                withKubeConfig ([credentialsId: 'kubeconfig']) {
                    sh 'sed -i "s/{{TAG}}/$tag_version/g" /jornadadevops_kube-news/k8s/deployment_web.yaml'
                    sh "kubectl apply -f './jornadadevops_kube-news/k8s/*.yaml'"
                }
            }
        }
    }
}
