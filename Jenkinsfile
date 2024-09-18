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
                sh 'docker system prune'
                sh 'docker rm --force test'
                sh 'docker run -dit --name test -p 5000:5000 833923550005.dkr.ecr.eu-central-1.amazonaws.com/jenkins-repo:$GIT_COMMIT'
            }
        }

        stage('Smoke Tests'){
            steps{
                echo "Running simple test"
                sleep 5
                // Use curl to check health and fail the build if the status is not 200
                sh '''
                    status_code=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:5000/health)
                    if [ "$status_code" -ne 200 ]; then
                        echo "Health check failed with status code: $status_code"
                        exit 1
                    else
                        echo "Health check passed with status code: $status_code"
                    fi
                '''
            }
        }
    }
}