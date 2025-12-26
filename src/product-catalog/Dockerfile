# Dockerfile for Product Catalog Service
# Build Stage
# Use official Golang image as the build environment
FROM golang:1.22-alpine AS builder

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the entire project into the container
COPY . .

# Download Go module dependencies
RUN go mod download

# Build the Product Catalog service and store the binary 
# in the product-catalog directory
RUN go build -o product-catalog .

# Release Stage
# Use a minimal Alpine Linux image for the final container
# This keeps the final image small and secure
FROM alpine AS release

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the products directory from the build stage to the release stage
COPY ./products/ ./products/

# Copy the built Product Catalog binary from the builder stage
COPY --from=builder /usr/src/app/product-catalog/ ./

# Expose the port that the Product Catalog service will run on
ENV PRODUCT_CATALOG_PORT=8088

# Define the entry point to run the Product Catalog service
ENTRYPOINT [ "./product-catalog" ]