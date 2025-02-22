pipeline {
    agent any

    environment {
        // Git Configurations
        GIT_REPO = "github.com/NubeEra-MCO/SpringBoot-H2-LoginReg.git"
        GIT_CREDENTIALS = "github-pat" 

        // Docker Configurations
        DOCKER_IMAGE = 'springboot-loginreg-h2'
        DOCKER_IMAGE_VERSION = 'v1' 
        DOCKER_CREDENTIALS = 'docker-hub-mujahed-credentials'
    }

    stages {
        // 1. Checkout Code
        stage('Checkout') {
            steps {
                script {
                    withCredentials([string(credentialsId: GIT_CREDENTIALS, variable: 'GIT_TOKEN')]) {
                        sh '''
                            if [ -d "SpringBoot-H2-LoginReg" ]; then
                                cd SpringBoot-H2-LoginReg
                                git pull origin main
                            else
                                git clone https://oauth:$GIT_TOKEN@$GIT_REPO
                            fi
                        '''
                    }
                }
            }
        }

        // 2. Maven Clean
        stage('Maven Clean') {
            steps {
                sh 'mvn clean'
            }
        }

        // 3. Maven Build
        stage('Maven Install') {
            steps {
                sh 'mvn install'
            }
        }


        stage('Check Docker Images') {
            steps {
                script {
                    sh '''
                        echo "Listing all existing Docker images..."
                        docker images
                    '''
                }
            }
        }


         stage('Check Dockerfile') {
            steps {
                script {
                    dir('SpringBoot-H2-LoginReg') {
                        sh '''
                            if [ -f Dockerfile ]; then
                                echo "✅ Dockerfile found!"
                            else
                                echo "❌ ERROR: Dockerfile not found!"
                                exit 1
                            fi
                        '''
                    }
                }
            }
        }


         stage('Docker Login') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                            echo "Logging into Docker Hub..."
                            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        '''
                    }
                }
            }
        }

        // // 4. Run Spring Boot
        // stage('Run Spring Boot') {
        //     steps {
        //         sh 'echo "Skipping Spring Boot Run..."'
        //     }
        // }

        // 5. Docker Info (Check if Docker is installed)
        // stage('Check Docker') {
        //     steps {
        //         script {
        //             sh '''
        //                 if ! command -v docker &> /dev/null; then
        //                     echo "Docker is not installed. Exiting..."
        //                     exit 1
        //                 else
        //                     docker --version
        //                 fi
        //             '''
        //         }
        //     }
        // } 

        // 6. Build Docker Image
        // stage('Build Docker Image') {
        //     steps {
        //         script {
        //             dir('SpringBoot-H2-LoginReg') {
        //                 sh '''
        //                     echo "Building Docker Image..."
        //                     docker build -t ${DOCKER_IMAGE}:${DOCKER_IMAGE_VERSION} .
        //                 '''
        //             }
        //         }
        //     }
        // }

        // 7. Push Docker Image
        // stage('Push Docker Image') {
        //     steps {
        //         script {
        //             withCredentials([string(credentialsId: DOCKER_CREDENTIALS, variable: 'DOCKER_PASS')]) {
        //                 sh '''
        //                     echo "Logging into Docker Hub..."
        //                     echo $DOCKER_PASS | docker login -u mauryaajay1661 --password-stdin
        //                     docker tag ${DOCKER_IMAGE}:${DOCKER_IMAGE_VERSION} mauryaajay1661/${DOCKER_IMAGE}:${DOCKER_IMAGE_VERSION}
        //                     docker push mauryaajay1661/${DOCKER_IMAGE}:${DOCKER_IMAGE_VERSION}
        //                 '''
        //             }
        //         }
        //     }
        // }
    }


}
