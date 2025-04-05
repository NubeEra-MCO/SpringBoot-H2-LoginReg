FROM openjdk:8-jdk-alpine
COPY target/UserRegistration1-0.0.1-SNAPSHOT.jar /app/app.jar
COPY src/main/resources /app/resources

# Set the working directory
WORKDIR /app

# Expose the application port
EXPOSE 8081

ENTRYPOINT ["java","-jar","app.jar"]
