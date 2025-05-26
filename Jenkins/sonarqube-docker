pipeline {
    agent any

    environment {
        MY_SONAR = tool "sonarqubescanner"
    }

    stages {
        stage('Clone the project') {
            steps {
                git branch: "master", url: "https://github.com/uday5252/flask-web-app.git"
            }
        }

        stage('Scanning using sonarqube scanner') {
            steps {
                withSonarQubeEnv("sonarqubedata") {
                    sh "$MY_SONAR/bin/sonar-scanner -Dsonar.projectName=flask-web-app -Dsonar.projectKey=flask-web-app"
                }
            }
        }

        stage('Generate Docker Image') {
            steps {
                sh "docker build -t atchu17/pythonapp:${BUILD_NUMBER} ."
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Dockerdata', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                }
            }
        }

        stage('Push the image to Docker Hub') {
            steps {
                sh "docker push atchu17/pythonapp:$BUILD_NUMBER"
            }
        }
    }
}
