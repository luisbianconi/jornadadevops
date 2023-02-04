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
            steps {
                withKubeConfig ([credentialsId: 'kubeconfig']) {
                    sh "kubectl apply ./jornadadevops_kube-news/k8s/*"
                }
            }
        }
    }
}
