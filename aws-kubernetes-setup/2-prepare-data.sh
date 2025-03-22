

# create a variable for the S3 bucket
connectBucketS3() {
    export ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
    export SAGEMAKER_BUCKET=ack-sagemaker-bucket-$ACCOUNT_ID

    chmod +x create-bucket.sh
    ./create-bucket.sh

    copyDataIntoBucketS3
}


# Copy the MNIST data into your S3 bucket
copyDataIntoBucketS3() {
    wget https://raw.githubusercontent.com/aws-controllers-k8s/sagemaker-controller/main/samples/training/s3_sample_data.py
    python3 s3_sample_data.py $SAGEMAKER_BUCKET
}


connectBucketS3
