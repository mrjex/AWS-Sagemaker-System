# Implementation Details

## Table of Contents
- [Implementation Details](#implementation-details)
  - [Table of Contents](#table-of-contents)
  - [Dataset](#dataset)
    - [Format](#format)
    - [Model Classification](#model-classification)
    - [Example Request](#example-request)
  - [AWS Console Setup](#aws-console-setup)

## Dataset

This project implements an ML model for flower classification using the [Iris Dataset](https://archive.ics.uci.edu/dataset/53/iris).

### Format
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



## AWS Console Setup

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