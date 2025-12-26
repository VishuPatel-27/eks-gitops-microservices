# Use the official Python image as a base image
FROM python:3.12-slim-bookworm AS base

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the requirements file into the container
COPY requirements.txt ./

# Install the required Python packages
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Install OpenTelemetry instrumentation
RUN opentelemetry-bootstrap -a install 

# Expose the port that the recommendation service will run on
ENV RECOMMENDATION_PORT=1010

# Define the command to run the recommendation service
ENTRYPOINT ["python", "recommendation_server.py"]
