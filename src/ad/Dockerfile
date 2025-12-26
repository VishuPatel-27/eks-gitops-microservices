# Build stage
# This stage compiles the application and prepares it for deployment
# Base image with JDK for building the application
FROM eclipse-temurin:21-jdk AS builder

# Set the working directory inside the container
WORKDIR /usr/src/app/

# Copy Gradle wrapper and build files
# This includes gradlew, settings.gradle, build.gradle, and the gradle directory,
# which are necessary for building the project
COPY gradlew* settings.gradle* build.gradle /usr/src/app/
COPY ./gradle ./gradle

# Give execute permission to the Gradle wrapper and run initial Gradle tasks
RUN chmod +x ./gradlew
# 1. Download Gradle dependencies
# 2. Download necessary repositories
# These steps help in caching dependencies for faster builds in subsequent runs
RUN ./gradlew
RUN ./gradlew downloadRepos

# Copy the rest of the application source code and protobuf files
# This includes all source files needed to build the application
COPY . .
# This specifically copies protobuf files to a designated proto directory
# Protobuf files are used for defining the structure of the data exchanged by the application
COPY ./pb ./proto
# Give execute permission to the Gradle wrapper and run initial Gradle tasks
RUN chmod +x ./gradlew
RUN ./gradlew installDist -PprotoSourceDir=./proto

#####################################################
# Deployment stage
# This stage creates a lightweight image for running the application
FROM eclipse-temurin:21-jre

# Set the working directory inside the container
WORKDIR /usr/src/app/

# Copy the built application from the builder stage
COPY --from=builder /usr/src/app/ ./

# Expose the application port
ENV AD_PORT 9099

# Set the entry point to run the application
ENTRYPOINT ["./build/install/opentelemetry-demo-ad/bin/Ad"]

