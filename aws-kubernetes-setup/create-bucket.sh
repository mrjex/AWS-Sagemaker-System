
#!/usr/bin/env bash
# Create the S3 bucket
if [[ $SERVICE_REGION != "us-east-1" ]]; then
  aws s3api create-bucket --bucket "$SAGEMAKER_BUCKET" --region "$SERVICE_REGION" --create-bucket-configuration LocationConstraint="$SERVICE_REGION"
else
  aws s3api create-bucket --bucket "$SAGEMAKER_BUCKET" --region "$SERVICE_REGION"
fi