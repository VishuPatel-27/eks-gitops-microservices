# Terraform configuration for AWS EKS cluster with VPC module
# Using S3 backend for state management
# Define provider and modules for VPC and EKS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = var.terraform_s3_bucket_name
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = var.terraform_dynamoDB_state_lock
    encrypt        = true
  }
}

# AWS Provider Configuration
provider "aws" {
  region = var.region
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  cluster_name         = var.cluster_name
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  node_groups     = var.node_groups
}