gcloud services enable container.googleapis.com sqladmin.googleapis.com

gcloud config set compute/zone us-east1-b

export PROJECT_ID=rknlhrqy
export WORKING_DIR=$(pwd)

export CLUSTER_NAME=persistent-disk-tutorial1

gcloud container clusters create $CLUSTER_NAME --num-nodes=3 --enable-autoupgrade --no-enable-basic-auth --no-issue-client-certificate --enable-ip-alias --metadata disable-legacy-endpoints=true

