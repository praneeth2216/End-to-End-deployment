Kubernetes pipeline

pipeline {
    agent any

    stages {

        stage('Cloning from github') {
            steps {
                git branch: 'master', url: 'https://github.com/uday5252/flask-web-app.git'
            }
        }

        stage('Connect to the AWS and EKS Cluster') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'eksdata'
                ]]) {
                    sh '''
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws configure set region ap-south-1
                        aws eks update-kubeconfig --region ap-south-1 --name project-cluster
                    '''
                }
            }
        }

        stage('Deployment of flask application on EKS') {
            steps {
                sh 'kubectl apply -f ./deployment.yaml'
            }
        }

    }
}
