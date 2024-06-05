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
  1. AWS CLI Installed

     1.1 curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
     
     1.2 apt install unzip
     
     1.3 unzip awscliv2.zip
     
     1.4 sudo ./aws/install
     
  2. AWS CLI Configure
    AWS_AK=""

    AWS_SAK=""
    
    AWS_REGION="us-east-1"      # North Virginia region
    
    AWS_FORMAT="json"
     
     bash ```
         configure_aws_cli() {
          echo "Configuring AWS CLI..."
          aws --profile default configure set aws_access_key_id $AWS_AK
          aws --profile default configure set aws_secret_access_key $AWS_SAK
          aws --profile default configure set region $AWS_REGION
          aws --profile default configure set output $AWS_FORMAT 
        }
     ```
  4. Connect
     
       docker login
     
  5. Connect to ECR using:
     
       aws ecr-public get-login-password \
         --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/n5v3a6h2
