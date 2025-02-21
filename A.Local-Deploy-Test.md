# A. Local Deploy and Test Steps

## Update System and Install Java 17
```bash
  sudo su
  apt update
```
 ## Install Java 17
```bash
  apt install openjdk-17-jdk -y
```
## Verify Java installation
```bash
  java -version
  javac -version
  ls /usr/lib/jvm/java-1.17.0-openjdk-amd64
```

## Update in BashRC File
```bash
nano ~/.bashrc

export JAVA_HOME=/usr/lib/jvm/java-1.17.0-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH


source ~/.bashrc
```
## Verify BashRC Applied to Current Shell
```bash
echo $JAVA_HOME
echo $PATH
```

## Install Maven, Build and Test
apt install -y maven

mvn clean 
mvn install
mvn spring-boot:run

## Verify Application

http://PublicIP:8080


Register with Following details:


mujahed1@gmail.com

