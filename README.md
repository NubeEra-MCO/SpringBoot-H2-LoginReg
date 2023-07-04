# User(Registration & Login) with SpringBoot & H2
User (Registration & Login) using Spring Boot, Data JPA, in-memory H2 db.

## Application Requires/Java Dependencies:
- Java JDK 1.8
- Maven 
- Spring Boot
- Spring Web
- Spring Data JPA
- H2 database(embedded)

## Front end UI:
- Html,CSS & JSP(Java Server Pages)

## Backend(Database)
- Browse:         http://localhost:8080/h2-console
- Setting Name:   Generic H2 (Embedded)
- Driver Class:   org.h2.Driver
- JDBC URL:       jdbc:h2:mem:userDb
- UserName:       sa
- Password:       123

## Build + Run:
`$ mvn install`
`$ mvn clean spring-boot:run`

## Run the -war / -jar from target:

`$ java -jar target/name-of-SNAPSHOT.jar`

Make sure to use java 1.8

`java -version`

### Windows
`$ set JAVA_HOME="$(c:\\program files\\openlogic-openjdk-8u372-b07-windows-64)"`
### Linux/Mac OS
`$ export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"`

## Steps for running different modules:
### 1)/signup
  - Browse http://localhost:8080/
  - Select signup link.
  - Add details for signup.
  - User details are saved in embeded H2 database
  - Browse http://localhost:8080/h2-console
  - User is directed to successful signup page.
### 2)/login
  - Browse http://localhost:8080/
  - Select login link.
  - Add email and password.
  - User is redirected to dummy page after successful login.

#### Note- Embedded database is used so every time project is relaunched signup must be done before login or Else, sample data is stored in resources/data.sql file
