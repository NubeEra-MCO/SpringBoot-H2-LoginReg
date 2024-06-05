# On Prem
sudo su
apt update
apt install openjdk-8-jdk -y
apt install maven -y
git clone https://github.com/NubeEra-MCO/SpringBoot-H2-LoginReg.git -b br-k8s
cd SpringBoot-H2-LoginReg
mvn clean
mvn install 
java -jar ./target/UserRegistration1-0.0.1-SNAPSHOT.jar

# Docker Container
apt  install docker.io -y
docker info
docker --version
## Build Local Custom Image
docker images
docker build -t springbooth2:mujahed1 .
docker run --name contspringbooth2 -p 8080:8080 -d springbooth2:mujahed1

# Pushing to ECR 
