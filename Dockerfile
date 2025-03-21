# Use a base image with Java and Maven
FROM maven:3.9.5-openjdk-17 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml file to download dependencies
COPY pom.xml .

# Download Maven dependencies (this will be cached in subsequent builds)
RUN mvn dependency:go-offline

# Copy the entire project source code
COPY src ./src

# Package the application using Maven
RUN mvn clean package -DskipTests

# Use a lightweight JRE base image for the runtime environment
FROM openjdk:17-jre-slim

# Set the working directory
WORKDIR /app

# Copy the packaged JAR file from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose the port the application runs on (if applicable)
EXPOSE 8080

# Define the command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
