pipeline {
    agent any

    environment {
        AWS_REGION = 'eu-central-1'
        ECR_REPO_NAME = 'jenkins-repo'
        ECR_REGISTRY = "833923550005.dkr.ecr.eu-central-1.amazonaws.com/jenkins-repo"
        IMAGE_REPO_NAME = "${ECR_REGISTRY}/${ECR_REPO_NAME}"
        KUBECONFIG_CREDENTIALS_ID = 'kubeconfig-credentials'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_REPO_NAME}:${env.BUILD_ID}")
                }
            }
        }

        stage('Login to AWS ECR') {
            steps {
                script {
                    withAWS(region: "${AWS_REGION}", credentials: 'aws-credentials-id') {
                        sh 'aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}'
                    }
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    docker.withRegistry("https://${ECR_REGISTRY}", "") {
                        dockerImage.push("${env.BUILD_ID}")
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([file(credentialsId: "${KUBECONFIG_CREDENTIALS_ID}", variable: 'KUBECONFIG')]) {
                    sh '''
                    helm upgrade --install my-app ./helm/my-app \
                        --set image.repository=${IMAGE_REPO_NAME} \
                        --set image.tag=${BUILD_ID} \
                        --kubeconfig $KUBECONFIG
                    '''
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
