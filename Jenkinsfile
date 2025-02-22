
pipeline {
    agent any

    environment {
        // GIT CONFIGURATIONS
        /////////////////////
        GIT_REPO = "https://github.com/NubeEra-MCO/SpringBoot-H2-LoginReg.git"  // Added full URL
        GIT_CREDENTIALS = "github-pat" // The credential ID you set in Jenkins

        // DOCKER CONFIGURATIONS
        //////////////////////
        DOCKER_IMAGE = 'springboot-loginreg-h2' // Change this to your Docker Hub repository
        DOCKER_IMAGE_VERSION = 'v1' 
        DOCKER_CREDENTIALS = 'docker-hub-mujahed-credentials' // Add your Docker credentials ID from Jenkins
    }

    stages {
        // 1. Clone Repo
        stage('Checkout') {
            steps {
                script {
                    withCredentials([string(credentialsId: GIT_CREDENTIALS, variable: 'GIT_TOKEN')]) {
                        sh "git clone https://oauth:${GIT_TOKEN}@${GIT_REPO}"
                    }
                }
            }
        }

        // 2. Clean Project
        stage('Maven Clean') {
            steps {
                sh 'echo "----------------------------------------------------------------Cleaning START----------------------------------------------------------------"'
                sh 'mvn clean'
                sh 'echo "----------------------------------------------------------------Cleaning END----------------------------------------------------------------"'
            }
        }

        // 3. Generate Artifact
        stage('Maven Install') {
            steps {
                sh 'echo "----------------------------------------------------------------Building START----------------------------------------------------------------"'
                sh 'mvn install'
                sh 'echo "----------------------------------------------------------------Building END------------------------------------------------------------------"'
            }
        }

        // 4. Run Project Locally
        stage('Run Spring Boot') {
            steps {
                sh 'echo "----------------------------------------------------------------Run START----------------------------------------------------------------"'
                sh 'mvn spring-boot:run'
                sh 'echo "----------------------------------------------------------------Run END------------------------------------------------------------------"'
            }
        }

        // 5. Test Docker Info
        stage('Run Docker Container') {
            steps {
                script {
                    sh """
                        echo "----------------------------------------------------------------DOCKER INFO----------------------------------------------------------------"
                        docker info
                        # docker run -d -p 8081:8081 --name springboot-app ${DOCKER_IMAGE}:latest  // Commented out code
                        echo "----------------------------------------------------------------DOCKER INFO----------------------------------------------------------------"
                    """
                }
            }
        }

        // 6. Build Docker Image
        stage('Build Docker Image') {
            steps {
                script {
                    // Navigate to the directory where the Dockerfile is located
                    dir('SpringBoot-H2-LoginReg') { // Adjust this if your repo structure is different
                        sh "echo '----------------------------------------------------------------BUILDING START----------------------------------------------------------------'"
                        sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_IMAGE_VERSION} ."
                        sh "echo '----------------------------------------------------------------BUILDING END----------------------------------------------------------------'"
                    }
                }
            }
        }
    }
}
post {
    // Cleanup actions
    always {
        script {
            // Optionally, you can clean up the workspace
            cleanWs()
        }
    }
}