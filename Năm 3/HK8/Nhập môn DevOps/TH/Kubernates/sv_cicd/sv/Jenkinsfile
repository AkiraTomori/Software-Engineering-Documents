def helmValues = "/var/lib/jenkins/workspace/${JOB_NAME}/app-demo/values.yaml"
def helmChart = "/var/lib/jenkins/workspace/${JOB_NAME}/app-demo/"

pipeline {
    agent any

    parameters {
        string(name: 'BRANCH_NAME', defaultValue: 'dev', description: 'Git branch to build')
    }

    environment {
        REPO_URL = 'https://github.com/ntquan/nodejs-app-ci-cd.git'
        BRANCH_NAME = "${params.BRANCH_NAME}"
        IMAGE_NAME = 'ntquan87/nodejs-app-ci-cd'
    }


    stages {
        stage('Print Branch Name') {
            steps {
                script {
                    echo "Branch selected: ${BRANCH_NAME}"
                }
            }
        }
        stage('Checkout') {
            steps {
                script {
                    // Checkout the specified branch
                    git branch: "${BRANCH_NAME}", url: "${REPO_URL}"
                }
            }
        }

        stage('Get Latest Commit') {
            steps {
                script {
                    // Get the latest commit hash
                    LATEST_COMMIT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    echo "Latest Commit Hash: ${LATEST_COMMIT}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image with the commit hash as a tag
                    sh "whoami"
                    sh "docker build -t ${IMAGE_NAME}:${LATEST_COMMIT} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the image to Docker registry (optional)
                    sh "docker push ${IMAGE_NAME}:${LATEST_COMMIT}"
                }
            }
        }
        stage('Apply k8s') {
            steps {
                script {
                    echo "Deploy to k8s"
                    sh "helm upgrade --install --namespace=test-${LATEST_COMMIT}  --create-namespace jenkins-${LATEST_COMMIT} -f $helmValues $helmChart --set image.repository=${IMAGE_NAME} --set image.tag=${LATEST_COMMIT}"
                }
            }
        }
    }

    // post {
    //     always {
    //         // Clean up Docker images and containers
    //         cleanWs()
    //         sh 'docker system prune -af'
    //         sh 'docker logout'
    //     }
    // }
}
