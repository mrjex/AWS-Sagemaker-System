# AWS SageMaker ML System

> Leveraging AWS SageMaker for Scalable Machine Learning Model Deployment

[![AWS](https://img.shields.io/badge/AWS-Powered-orange)](https://aws.amazon.com/)
[![SageMaker](https://img.shields.io/badge/SageMaker-ML-blue)](https://aws.amazon.com/sagemaker/)
[![Python](https://img.shields.io/badge/Python-3.8+-green)](https://www.python.org/)
[![Status](https://img.shields.io/badge/Status-Completed-success)](https://github.com/yourusername/AWS-Sagemaker-System)

## Table of Contents
- [AWS SageMaker ML System](#aws-sagemaker-ml-system)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [System Architecture](#system-architecture)
    - [Implementation Details](#implementation-details)
  - [Project Purpose](#project-purpose)
    - [Data Format](#data-format)
    - [Model Classification](#model-classification)
    - [Example Request](#example-request)
  - [Testing Framework](#testing-framework)
    - [Automated Tests](#automated-tests)
  - [Kubernetes Integration](#kubernetes-integration)
    - [Key Features](#key-features)
    - [Deployment Options](#deployment-options)
  - [My Related Projects](#my-related-projects)
    - [Python Notebooks](#python-notebooks)
    - [AI \& ML Projects](#ai--ml-projects)
  - [Monitoring \& Logging](#monitoring--logging)

## Overview

During July 23-26, 2024, I developed this project to explore Machine Learning deployment using AWS SageMaker. The system leverages SageMaker's serverless inference endpoints and conda_python3 kernel for model development, demonstrating scalable ML model deployment in production environments.

## System Architecture

The solution integrates multiple AWS services into a seamless ML pipeline:

![architecture](readme-pictures/1.%20architecture.PNG)

Key Components:
- **SageMaker Notebook**: Development environment for ML models
- **SageMaker Endpoint**: Serverless inference deployment
- **Lambda Function**: Request processing and model interaction
- **API Gateway**: RESTful API management

### Implementation Details

1. **SageMaker Setup**
   
   *Notebook Instance:*
   ![notebooks](readme-pictures/2.%20sagemaker-notebooks.PNG)

   *Endpoint Configuration:*
   ![endpoint](readme-pictures/4.%20sagemaker-endpoint.PNG)

2. **Lambda Integration**
   
   *Function Configuration:*
   ![lamba-function](readme-pictures/6.%20lambda-func2.PNG)

3. **API Gateway Configuration**
   
   *Lambda Connection:*
   ![gateway-connect](readme-pictures/7.%20restful-api-gateway1.PNG)

## Project Purpose

This project implements an ML model for flower classification using the [Iris Dataset](https://archive.ics.uci.edu/dataset/53/iris).

### Data Format
Each instance contains:
- Sepal length (cm)
- Sepal width (cm)
- Petal length (cm)
- Petal width (cm)
- Flower type classification

### Model Classification
The model maps predictions to three flower types:

0.0 → 'Iris Setosa'
1.0 → 'Iris Versicolour'
2.0 → 'Iris Virginica'

### Example Request
```json
{
    "x1": 5.1,
    "x2": 3.5,
    "x3": 1.4,
    "x4": 0.2
}
```

*Successful API Response:*
![successful-response](readme-pictures/8.%20restful-api-gateway3.PNG)

## Testing Framework

Our comprehensive testing suite includes:

![api-test-results](readme-pictures/11.%20api-tests-results.PNG)

### Automated Tests
1. **Shell Tests**
   - Randomized data selection
   - Dynamic JSON body generation
   - Automated endpoint validation

2. **Postman Tests**
   - Pre-configured test scenarios
   - Automated execution via shell scripts
   - Comprehensive API validation

![api-shell-tests](readme-pictures/12.%20api-tests-shell-json-architecture.PNG)

## Kubernetes Integration

### Key Features
- **SageMaker Operators for Kubernetes**
  - Workflow management
  - Distributed training
  - Scalable inference endpoints

### Deployment Options
1. **Training Workflows**
   - Custom resource definitions
   - kubectl integration
   - Automated provisioning

2. **Inference Endpoints**
   - Elastic scaling
   - Framework support (TensorFlow, PyTorch, MXNet)
   - YAML configuration

## My Related Projects

### Python Notebooks
- [US Political Data Visualization](https://github.com/mrjex/US-Political-and-Societal-Data-Visualization)
- [ML Clustering System](https://github.com/mrjex/Machine-Learning-Clustering-System)

### AI & ML Projects
- [Neural Network Classification](https://github.com/mrjex/Neural-Network-Image-Classification)
- [AI Classifiers](https://github.com/mrjex/Artificial-Intelligence-Classifiers)
- [AI Clusters](https://github.com/mrjex/Artificial-Intelligence-Clusters)

## Monitoring & Logging

- CloudWatch integration for API performance monitoring
- Detailed metrics and logging
- Performance optimization insights