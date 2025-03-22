createClusterEKS() {
    eksctl create cluster --name "${CLUSTER_NAME}" --region "${CLUSTER_REGION}"
}


CLUSTER_NAME="sm-operator-demo"
CLUSTER_REGION="eu-north-1"


# createClusterEKS