# Use a base image with the JDK and necessary build tools installed
FROM openjdk:11-jdk-slim

# Set the working directory to /app
WORKDIR /app

# Copy the Gradle project files to the container
COPY . .

# Run the Gradle build command
RUN chmod +x gradlew
RUN ./gradlew build

# Set the command to run the application
CMD ["java", "-jar", "build/libs/*.jar"]
