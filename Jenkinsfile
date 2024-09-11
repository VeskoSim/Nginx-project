pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                sh 'docker build -t "jenkins-repo:$GIT_COMMIT" .'
            }
        }
        stage('Push') {
            steps {
                echo 'Pushing and autentication to registry..'
                sh 'aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 833923550005.dkr.ecr.eu-central-1.amazonaws.com'
                sh 'docker tag jenkins-repo:$GIT_COMMIT 833923550005.dkr.ecr.eu-central-1.amazonaws.com/jenkins-repo:$GIT_COMMIT'
                sh 'docker push 833923550005.dkr.ecr.eu-central-1.amazonaws.com/jenkins-repo:$GIT_COMMIT'
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                sh 'docker run -dit --name viewme -p 5000:5000 833923550005.dkr.ecr.eu-central-1.amazonaws.com/jenkins-repo:$GIT_COMMIT'
            }
        }
    }
}