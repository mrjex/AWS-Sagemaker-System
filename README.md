# Sagemaker AWS Prediction

During 23rd-26th July 2024 I worked on this project to gain knowledge about Machine Learning and Amazon Web Services. I used Amazon Sagemaker to deploy a serverless inference endpoint, and the ML model was developed using *conda_python3* kernel from a notebook instance. In essence, Amazon Sagemeker builds, trains and deploys machine learning models at scale.


## Related Experiences

### Python Notebooks

  - [Computer Programming & Data Manamgent - 2](https://gitlab.com/jex-projects/mrjex/-/tree/main/projects/1.%20courses/year-3/1.%20Exchange%20Studies%20Venice/4.%20Computer%20Programming%20&%20Datamanagement%20-%202?ref_type=heads): *Used **Google Collab Jupyter notebooks** to create a presentation with multiple data visualizations, to ultimately draw conclusions about behavioral aspects and tendencies of society*
  - [Data Science & Business Intelligence](https://gitlab.com/jex-projects/mrjex/-/tree/main/projects/1.%20courses/year-3/1.%20Exchange%20Studies%20Venice/5.%20Data%20Science%20&%20Business%20Intelligence?ref_type=heads): *Used **Google Collab Jupyter notebooks** to implement machine learning models in the domain of unsupervised clustering such as **K-Means**, **Spectral Clustering** and **Agglomerative Clustering***


### Artificial Intelligence & Machine Learning

  - [Foundations of Artificial Intelligence](https://gitlab.com/jex-projects/mrjex/-/tree/main/projects/1.%20courses/year-3/1.%20Exchange%20Studies%20Venice/1.%20Foundations%20of%20Artificial%20Intelligence?ref_type=heads): *Implemented **classifiers and clustering methods** in the field of Artificial Intelligence and Machine Learning*
  - [Foundations of Machine Learning](https://gitlab.com/jex-projects/mrjex/-/tree/main/projects/1.%20courses/year-3/1.%20Exchange%20Studies%20Venice/2.%20Foundations%20of%20Machine%20Learning?ref_type=heads): *Used **Kaggle Notebooks** to implement a **Convolutional Neural Network (CNN)***



## Sagemaker Prediction Project


![architecture](readme-pictures-1/1.%20architecture.PNG)


1) Set up SageMaker

*Notebook instance:*
![notebooks](readme-pictures-1/2.%20sagemaker-notebooks.PNG)

*Endpoint:*
![endpoint](readme-pictures-1/4.%20sagemaker-endpoint.PNG)


1) Setup AWS Lambda Function

*Lambda Function:*
![lamba-function](readme-pictures-1/6.%20lambda-func2.PNG)


1) Setup Amazon API Gateway

*Connect Lambda to Gateway:*
![gateway-connect](readme-pictures-1/7.%20restful-api-gateway1.PNG)


1) Test the architecture

Note that I mapped the flower-types as follows (for more info on dataset check [Purpose of Project](#purpose-of-project)):
- 0.0:   -->   'Iris Setosa'
- 1.0:   -->   'Iris Versicolour'
- 2.0:   -->   'Iris Virginica'


*Successful RESTFUL API response:*
![successful-response](readme-pictures-1/8.%20restful-api-gateway3.PNG)


## Purpose of Project

This project trains a ML-model on the data found in `/data` such that it learns to recognize relations between the parameters *(the columns representing properties of an instance in the data files)*. Then, we provide a few parameters and let the model predict what class it belongs to. To understand the application in this project, it's important to understand the [Dataset](https://archive.ics.uci.edu/dataset/53/iris):

Each instance has the following format, where the first 4 columns are measured in centimeters, and the 5th one can be either *Iris Setosa*, *Iris Versicolour* or *Iris Virginica*:
`sepal length, sepal width, petal length, petal width, type of flower`

The model recieves a JSON request body that contains the four first attributes and returns the estimated type of flower, based on commonalities of sepal and petal lengths of that flower.

An example request body is:
`{"x1": 5.1, "x2": 3.5, "x3": 1.4, "x4": 0.2}`

And the expected result returned would be `Iris-setosa`

## Tests

In essence, the automated tests developed in `/api-tests` runs the AWS Lambda function that connects to the Sagemaker endpoint. Below are the two types of automated tests that I developed:

![api-test-results](readme-pictures-1/11.%20api-tests-results.PNG)


- **Shell tests:** *Randomize in the range (1-150) such that the resulting number is representative of the row of data to be tested*
   - Covers files in `/api-tests`: *data-manager.sh*, *shell-tests.sh*, *row-data.json*, *current-req-body.json*

- **Postman tests:** *Runs pre-selected tests of the exported Postman JSON file via shell scripts*
   - Covers files in `/api-tests`: *postman-tests.json*, *postman-tests.sh*,  *data-manager.sh*

![api-shell-tests](readme-pictures-1/12.%20api-tests-shell-json-architecture.PNG)

One problem that I encountered in the development of the shell-script-tests was that POST requests with the 'curl' command would only let me pass a body with fixed values. The moment I passed variables as the values of the JSON body a syntax error was induced. I then researched work arounds to this and found that you can use the content in a .json file to define the body of the request. In turn, I coupled this with my previous Bash experiences in my prior projects and manipulated the .json file in accordance to the desired values of the body. However, it wasn't until one of my later projects (my first [AI & Generative AI Project](https://gitlab.com/jex-projects/mrjex/-/tree/main/projects/2.%20spare-time/11.%20AWS%20Bedrock%20Generative%20AI?ref_type=heads) with AWS that I learned the quote-syntax for defining variables in this way without having to utilize a separate .json file)






## Kubernetes

- Use Amazon SageMaker Operators for Kubernetes to achieve the following things:

1. Use Kubernetes to manage your workflows, and get burst capacity with Amazon SageMaker for large-scale distributed training

2. Develop algorithms and models with Kubeflow Jupyter notebooks and run hyperparameter experiments at scale using Amazon SageMaker

3. Train models using Kubeflow and host an inference endpoint Amazon SageMaker that can elastically scale to millions of users?



----> You can use it to train machine learning models, optimize hyperparameters, run batch transform jobs, and set up inference endpoints using Amazon SageMaker, without ever leaving your Kubernetes cluster.


- Amazon SageMaker Operators for Kubernetes is a custom resource in Kubernetes that enables invoking Amazon SageMaker functionality using Kubernetes CLI and config files


- Using the Amazon SageMaker Operators for Kubernetes to submit Amazon SageMaker jobs via kubectl, just how you’d submit other Kubernetes jobs. Behind the scenes an Amazon SageMaker managed cluster with specified number of instances will be provisioned automatically for you.


- Use Amazon SageMaker Operators for Kubernetes to host inference endpoints via kubectl. Amazon SageMaker provisions the required instances and run model servers.


- If you’re working with widely used frameworks such as TensorFlow, PyTorch, MXNet, XGboost and others, all you have to do is upload your training script to Amazon S3 as a tar.gz file, and submit a training job to Amazon SageMaker via Kubernetes config file written in YAML

- Submit your Amazon SageMaker training job via Kubernetes’ kubectl





### AWS - EKS

- Amazon EKS exposes a Kubernetes API endpoint. Your existing Kubernetes tooling can connect directly to EKS managed control plane. Worker nodes run as EC2 instances in your account.



- For training a model with SageMaker, we will need an S3 bucket to store the dataset and model training artifacts



## AWS Cloudwatch

- Monitor API performance