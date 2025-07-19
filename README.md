# AWS SageMaker ML System

> Using AWS SageMaker for Scalable Machine Learning Model Deployment

[![AWS](https://img.shields.io/badge/AWS-Powered-orange)](https://aws.amazon.com/)
[![SageMaker](https://img.shields.io/badge/SageMaker-ML-blue)](https://aws.amazon.com/sagemaker/)
[![Python](https://img.shields.io/badge/Python-3.8+-green)](https://www.python.org/)
[![Status](https://img.shields.io/badge/Status-Completed-success)](https://github.com/yourusername/AWS-Sagemaker-System)

## Table of Contents
- [AWS SageMaker ML System](#aws-sagemaker-ml-system)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [System Architecture](#system-architecture)
  - [Automated Tests](#automated-tests)

## Overview

During July 23-26, 2024, I developed this project to explore Machine Learning deployment using AWS SageMaker. The system leverages SageMaker's serverless inference endpoints and conda_python3 kernel for model development, demonstrating scalable ML model deployment in production environments. This project implements an ML model for flower classification using the [Iris Dataset](https://archive.ics.uci.edu/dataset/53/iris).


## System Architecture

The solution integrates multiple AWS services into a seamless ML pipeline:

![architecture](readme-pictures/1.%20architecture.PNG)

Key Components:
- **SageMaker Notebook**: Development environment for ML models
- **SageMaker Endpoint**: Serverless inference deployment
- **Lambda Function**: Request processing and model interaction
- **API Gateway**: RESTful API management


## Automated Tests

![api-shell-tests](readme-pictures/12.%20api-tests-shell-json-architecture.PNG)

1. **Shell Tests**
   - Randomized data selection
   - Dynamic JSON body generation
   - Automated endpoint validation

2. **Postman Tests**
   - Pre-configured test scenarios
   - Automated execution via shell scripts
   - Comprehensive API validation

![api-test-results](readme-pictures/11.%20api-tests-results.PNG)
