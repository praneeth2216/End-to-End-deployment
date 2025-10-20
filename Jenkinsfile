pipeline {
  agent any
  parameters {
    string(name: 'IMAGE_TAG', defaultValue: '1.0', description: 'Docker image tag')
  }
  environment {
    DOCKERHUB_CREDENTIALS = 'dockerhub-credentials' // store as Jenkins credential (username/password)
    KUBECONFIG_CRED = 'kubeconfig' // store your kubeconfig as a Jenkins "Secret file" credential
    DOCKER_IMAGE = "praneeth2216/weekendflaskapp:${IMAGE_TAG}"
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Login to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
          sh 'echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin'
        }
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

    stage('Push Image') {
      steps {
        sh "docker push ${DOCKER_IMAGE}"
      }
    }
    stage('Prepare deployment') {
      steps {
        // Replace image tag inside a copied deployment file so original is preserved
        sh "cp Kuberentes/deployment.yaml Kuberentes/deployment-apply.yaml"
        // Prefer yq for robust YAML editing; fall back to sed if yq missing
        sh "if command -v yq >/dev/null 2>&1; then yq eval '.spec.template.spec.containers[0].image = \"${DOCKER_IMAGE}\"' -i Kuberentes/deployment-apply.yaml; else sed -i 's|image: .*|image: ${DOCKER_IMAGE}|' Kuberentes/deployment-apply.yaml; fi"
      }
    }
    stage('Deploy to Kubernetes') {
      steps {
        // Use kubeconfig secret file from Jenkins credentials and apply the modified deployment
        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_FILE')]) {
          // write kubeconfig to KUBECONFIG path used by kubectl
          sh 'export KUBECONFIG=$KUBECONFIG_FILE; kubectl apply -f Kuberentes/deployment-apply.yaml'
        }
      }
    }
  }
  post {
    always {
      sh 'docker image prune -f'
    }
  }
}
