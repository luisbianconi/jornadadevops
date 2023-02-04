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

    stage ('Build Docker Image') {
        steps {
            script {
                docker.withRegistry('https://registry.hub.docker.com', '1996') {
                    dockerapp.push('latest')
                    docker.app("${env.BUILD_ID}")
                }
            }
        }
    }
}