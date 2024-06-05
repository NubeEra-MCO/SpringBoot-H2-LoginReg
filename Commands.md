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
bash ```
	#Update Environment Variables
	export AWS_AK=""
    	export AWS_SAK=""    
    	export AWS_REGION="us-east-1"      # North Virginia region    
    	export AWS_FORMAT="json"
     
	# Configure AWS CLI
         configure_aws_cli() {
          echo "Configuring AWS CLI..."
          aws --profile default configure set aws_access_key_id $AWS_AK
          aws --profile default configure set aws_secret_access_key $AWS_SAK
          aws --profile default configure set region $AWS_REGION
          aws --profile default configure set output $AWS_FORMAT 
        }
    	aws s3 ls     
```
     
  4. Connect to ECR using:

	
       aws ecr-public get-login-password \
         --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/n5v3a6h2

      docker build -t sbh2mujahed:mujahed1 .

      docker tag sbh2mujahed:mujahed1 public.ecr.aws/n5v3a6h2/sbh2mujahed:mujahed1

      docker push public.ecr.aws/n5v3a6h2/sbh2mujahed:mujahed1


 4. Store Container Registry Image URL:     public.ecr.aws/n5v3a6h2/sbh2mujahed:mujahed1

 5. EKS Cluster(Role, Cluster)

bash ```
      PATTERN="mujahed1"
      AWS_EKS_CLUSTER_ROLE_NAME="eksrole-"$PATTERN

    cat > trust-policy.json <<EOF {
  "Version": "2012-10-17",
  "Statement": [
	{
		"Effect": "Allow",
		"Principal": {
			"Service": "eks.amazonaws.com"
		},
		"Action": "sts:AssumeRole"
	}
]
}
EOF

aws iam create-role \
    --role-name $AWS_EKS_CLUSTER_ROLE_NAME \
    --assume-role-policy-document file://trust-policy.json


aws iam attach-role-policy \
    --role-name $AWS_EKS_CLUSTER_ROLE_NAME \
    --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy

AWS_EKS_CLUSTER_NAME="eks"$PATTERN
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID="390480028815"
AWS_SUBNET_A="subnet-0a393b8709b836510"
AWS_SUBNET_B="subnet-02a1ba991bb2b4337"
AWS_SUBNET_C="subnet-0d1a15345c8f8bdf9"

aws eks create-cluster \
  --name $AWS_EKS_CLUSTER_NAME \
  --region $AWS_REGION \
  --kubernetes-version 1.29 \
  --role-arn arn:aws:iam::$AWS_ACCOUNT_ID:role/$AWS_EKS_CLUSTER_ROLE_NAME \
  --resources-vpc-config subnetIds=$AWS_SUBNET_A,$AWS_SUBNET_B,$AWS_SUBNET_C

aws eks wait cluster-active \
  --name $AWS_EKS_CLUSTER_NAME
```
  

    

6. Create EKS Node Group(Role, Node Group)

cat > node-trust-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
	  {
		  "Effect": "Allow",
		  "Principal": {
			  "Service": "ec2.amazonaws.com"
		  },
		  "Action": "sts:AssumeRole"
	  }
  ]
}
EOF
AWS_EKS_NODEGROUP_ROLE_NAME="eksng"$PATTERN
aws iam create-role \
    --role-name $AWS_EKS_NODEGROUP_ROLE_NAME \
    --assume-role-policy-document file://node-trust-policy.json



aws iam attach-role-policy \
    --role-name $AWS_EKS_NODEGROUP_ROLE_NAME \
    --policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy
aws iam attach-role-policy \
    --role-name $AWS_EKS_NODEGROUP_ROLE_NAME \
    --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
aws iam attach-role-policy \
    --role-name $AWS_EKS_NODEGROUP_ROLE_NAME \
    --policy-arn arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy


AWS_EKS_NODE_GROUP_NAME="ekcngcluster"$PATTERN
AWS_EKS_NODE_GROUP_INSTANCE_TYPE="t3.medium"

 aws eks create-nodegroup \
  --cluster-name $AWS_EKS_CLUSTER_NAME \
  --nodegroup-name $AWS_EKS_NODE_GROUP_NAME \
  --node-role arn:aws:iam::$AWS_ACCOUNT_ID:role/$AWS_EKS_NODEGROUP_ROLE_NAME \
  --subnets $AWS_SUBNET_A $AWS_SUBNET_B \
  --scaling-config minSize=1,maxSize=3,desiredSize=2 \
  --ami-type AL2_x86_64 \
  --instance-types $AWS_EKS_NODE_GROUP_INSTANCE_TYPE



# Connect AWS EKS to Arc-Enabled K8S Cluster

snap install kubectl --classic

kubectl version --client

# Configure kubectl
aws eks update-kubeconfig \
    --name $AWS_EKS_CLUSTER_NAME \
    --region $AWS_REGION

kubectl get nodes

Install AZ:      curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

az login

AZ_RG_NAME="rg"$PATTERN
AZ_LOCATION="eastus"

az group create \
    --name $AZ_RG_NAME  \
    --location $AZ_LOCATION


#Finding Correlation ID --> EKS Cluster
az monitor activity-log list \
    --resource-group $AZ_RG_NAME \
    --max-events 5 | grep correlationId

Correlation="5d6e8d0a-f3a4-4dd6-afea-8989f27bedd3"


az connectedk8s connect \
    --name "Arc-EKS-mujahed1" \
    --resource-group $AZ_RG_NAME \
    --location $AZ_LOCATION \
    --tags "Project=poc-arc-eks" \
    --correlation-id $Correlation

# Verify Connected or not
az connectedk8s list \
    --resource-group $AZ_RG_NAME \
    --output table


kubectl get deployments,pods -n azure-arc

az connectedk8s delete \
    -n "Arc-EKS-Demo" \
    -g  $AZ_RG_NAME \
    --force



 az connectedk8s connect --name Arc-EKS-mujahed1 --resource-group rgmujahed1








