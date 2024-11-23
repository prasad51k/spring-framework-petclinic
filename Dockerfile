# Use an official Maven image to build the project
FROM maven:3.8.5-openjdk-17 AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the source code
COPY src ./src

# Build the application
RUN mvn package -DskipTests

# Use a lightweight Tomcat image for deploying the WAR file
FROM tomcat:10.1-jdk17-corretto

# Set the working directory
WORKDIR /usr/local/tomcat/webapps

# Copy the WAR file from the build stage to Tomcat's webapps directory
COPY --from=build /app/target/petclinic.war ./ROOT.war

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
