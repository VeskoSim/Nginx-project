pipeline {
    agent any
    enviroment{
        VERSION='$GIT_COMMIT'
    }
    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                docker build -t "jenkins-repo:$VERSION" .
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}