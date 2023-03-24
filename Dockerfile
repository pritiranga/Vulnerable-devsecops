FROM openjdk:11-jdk-slim

RUN apt-get update 
RUN apt-get install wget -y 
RUN apt-get clean

# Install Gradle
ENV GRADLE_VERSION=7.1.1
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip -d /opt gradle-${GRADLE_VERSION}-bin.zip && \
    rm gradle-${GRADLE_VERSION}-bin.zip

ENV GRADLE_HOME=/opt/gradle-${GRADLE_VERSION}
ENV PATH=$PATH:$GRADLE_HOME/bin

# Copy the project files and build the application
COPY . /app
WORKDIR /app
RUN gradle build

CMD ["java", "-jar", "/app/build/libs/myapp.jar"]
