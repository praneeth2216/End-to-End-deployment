pipeline {
  agent any
  parameters {
    string(name: 'IMAGE_TAG', defaultValue: '1.0', description: 'Docker image tag')
  }
  environment {
    DOCKERHUB_CREDENTIALS = 'dockerhub-credentials' // store as Jenkins credential (username/password)
    DOCKER_IMAGE = "praneeth2216/weekendflaskapp:${IMAGE_TAG}"
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Build Docker Image') {
      steps {
        dir('docker') {
          script {
            sh "docker build -t ${DOCKER_IMAGE} -f dockerfile ."
          }
        }
      }
    }
    stage('Login to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: env.DOCKERHUB_CREDENTIALS, usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
          sh 'echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin'
        }
      }
    }
    stage('Push Image') {
      steps {
        sh "docker push ${DOCKER_IMAGE}"
      }
    }
    stage('Deploy to Kubernetes') {
      steps {
        // Assumes Jenkins agent has kubectl configured or kubeconfig stored as Jenkins credential
        sh 'kubectl apply -f Kuberentes/deployment.yaml'
      }
    }
  }
  post {
    always {
      sh 'docker image prune -f'
    }
  }
}