FROM openjdk:8-jdk-alpine
COPY target/UserRegistration1-0.0.1-SNAPSHOT.jar UserRegistration1-0.0.1.jar
ENTRYPOINT ["java","-jar","UserRegistration1-0.0.1.jar"]
