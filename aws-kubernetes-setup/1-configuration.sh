# https://aws-controllers-k8s.github.io/community/docs/tutorials/sagemaker-example/#setup


CLUSTER_NAME="sm-operator-demo"
CLUSTER_REGION="eu-north-1"




# Install/Configure SageMaker Operators for Kubernetes
configureSageMakerKubernetesOperators() {
    configurePermissionsIAM "${CLUSTER_NAME}" "${CLUSTER_REGION}"
}


configurePermissionsIAM() {

    ##  IAM PERMISSIONS  ##
    export CLUSTER_NAME="${CLUSTER_NAME}"
    export SERVICE_REGION="${CLUSTER_REGION}"
    aws eks update-kubeconfig --name $CLUSTER_NAME --region $SERVICE_REGION
    kubectl config get-contexts
    # Ensure cluster has compute
    kubectl get nodes


    ##  Associate OPENID with IAM  ##
    eksctl utils associate-iam-oidc-provider --cluster ${CLUSTER_NAME} \
        --region ${SERVICE_REGION} --approve

    export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
    export OIDC_PROVIDER_URL=$(aws eks describe-cluster --name $CLUSTER_NAME --region $SERVICE_REGION \
        --query "cluster.identity.oidc.issuer" --output text | cut -c9-)
    

    ##  Define trust-relationship for IAM role  ##
    createTrustJSON

    ##  Create IAM role with the trust-relationship derived from trust.json  ##
    export OIDC_ROLE_NAME=ack-controller-role-$CLUSTER_NAME
    aws --region $SERVICE_REGION iam create-role --role-name $OIDC_ROLE_NAME --assume-role-policy-document file://trust.json


    ##  Attach the AmazonSageMakerFullAccess Policy to the IAM Role to ensure that your
    ##  SageMaker service controller has access to the appropriate resources  ##
    aws --region $SERVICE_REGION iam attach-role-policy --role-name $OIDC_ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AmazonSageMakerFullAccess
    export IAM_ROLE_ARN_FOR_IRSA=$(aws --region $SERVICE_REGION iam get-role --role-name $OIDC_ROLE_NAME --output text --query 'Role.Arn')
    echo $IAM_ROLE_ARN_FOR_IRSA

    createAccessJSON
    aws --region $SERVICE_REGION iam put-role-policy --role-name $OIDC_ROLE_NAME --policy-name SagemakerStudioAccess --policy-document file://sagemaker_studio_access.json

    installSagemakerControllerACK
}



# Creates a JSON file whose that defines the trust-relationship for the IAM role
createTrustJSON() {
    printf '{
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::'$AWS_ACCOUNT_ID':oidc-provider/'$OIDC_PROVIDER_URL'"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                "'$OIDC_PROVIDER_URL':aud": "sts.amazonaws.com",
                "'$OIDC_PROVIDER_URL':sub": [
                    "system:serviceaccount:ack-system:ack-sagemaker-controller",
                    "system:serviceaccount:ack-system:ack-applicationautoscaling-controller"
                ]
                }
            }
            }
        ]
        }
        ' > ./trust.json
}


createAccessJSON() {
    printf '{
        "Version": "2012-10-17",
        "Statement": [
            {
            "Sid": "SagemakerStudioAccess",
            "Effect": "Allow",
            "Action": [
                "sagemaker:*"
            ],
            "Resource": [
                "arn:aws:sagemaker:*:*:domain/*",
                "arn:aws:sagemaker:*:*:user-profile/*",
                "arn:aws:sagemaker:*:*:app/*"
            ]
            }
        ]
        }
        ' > ./sagemaker_studio_access.json
}



# Install the SageMaker ACK service controller
installSagemakerControllerACK() {
    export HELM_EXPERIMENTAL_OCI=1
    export SERVICE=sagemaker
    export RELEASE_VERSION=$(curl -sL "https://api.github.com/repos/aws-controllers-k8s/${SERVICE}-controller/releases/latest" | jq -r '.tag_name | ltrimstr("v")')

    if [[ -z "$RELEASE_VERSION" ]]; then
    RELEASE_VERSION=v1.2.0
    fi

    export CHART_EXPORT_PATH=/tmp/chart
    export CHART_REF=$SERVICE-chart
    export CHART_REPO=public.ecr.aws/aws-controllers-k8s/$CHART_REF
    export CHART_PACKAGE=$CHART_REF-$RELEASE_VERSION.tgz

    mkdir -p $CHART_EXPORT_PATH

    helm pull oci://$CHART_REPO --version $RELEASE_VERSION -d $CHART_EXPORT_PATH
    tar xvf $CHART_EXPORT_PATH/$CHART_PACKAGE -C $CHART_EXPORT_PATH



    # Update the following values in the Helm chart
    cd $CHART_EXPORT_PATH/$SERVICE-chart
    yq e '.aws.region = env(SERVICE_REGION)' -i values.yaml
    yq e '.serviceAccount.annotations."eks.amazonaws.com/role-arn" = env(IAM_ROLE_ARN_FOR_IRSA)' -i values.yaml
    cd -

    kubectl apply -f $CHART_EXPORT_PATH/$SERVICE-chart/crds

    export ACK_K8S_NAMESPACE=ack-system
    helm install -n $ACK_K8S_NAMESPACE --create-namespace --skip-crds ack-$SERVICE-controller \
    $CHART_EXPORT_PATH/$SERVICE-chart

    verifyConfigurations
}


# Verify that the CRDs and Helm charts were deployed
verifyConfigurations() {

    kubectl get crds | grep "services.k8s.aws"
    kubectl get pods -n $ACK_K8S_NAMESPACE

    # Notes
    # Chart deployed: "public.ecr.aws/aws-controllers-k8s/sagemaker-controller:1.2.11"
    # Check status: kubectl --namespace ack-system get pods -l "app.kubernetes.io/instance=ack-sagemaker-controller"
}



configureSageMakerKubernetesOperators