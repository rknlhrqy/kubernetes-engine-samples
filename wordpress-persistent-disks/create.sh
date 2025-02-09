gcloud services enable container.googleapis.com sqladmin.googleapis.com

gcloud config set compute/zone us-east1-b

export PROJECT_ID=rknlhrqy
export WORKING_DIR=$(pwd)

export CLUSTER_NAME=persistent-disk-tutorial1

gcloud container clusters create $CLUSTER_NAME --num-nodes=3 --enable-autoupgrade --no-enable-basic-auth --no-issue-client-certificate --enable-ip-alias --metadata disable-legacy-endpoints=true --zone us-east1-b

kubectl apply -f $WORKING_DIR/wordpress-volumeclaim.yaml

kubectl get pvc

export INSTANCE_NAME=mysql-wordpress-instance

gcloud sql instances create $INSTANCE_NAME

export INSTANCE_CONNECTION_NAME=$(gcloud sql instances describe $INSTANCE_NAME --format='value(connectionName)')

gcloud sql databases create wordpress --instance $INSTANCE_NAME

export CLOUD_SQL_PASSWORD=$(openssl rand -base64 18)

gcloud sql users create wordpress --host=% --instance=$INSTANCE_NAME --password=$CLOUD_SQL_PASSWORD

export SA_NAME=cloudsqlproxy

gcloud iam service-accounts create $SA_NAME --display-name $SA_NAME

export SA_EMAIL=$(gcloud iam service-accounts list --filter=displayName:$SA_NAME --format='value(EMAIL)')

gcloud projects add-iam-policy-binding $PROJECT_ID --role roles/cloudsql.client --member serviceAccount:$SA_EMAIL

gcloud iam service-accounts keys create $WORKING_DIR/key.json --iam-account $SA_EMAIL

kubectl create secret generic cloudsql-db-credentials --from-literal username=wordpress --from-literal password=$CLOUD_SQL_PASSWORD

kubectl create secret generic cloudsql-instance-credentials --from-file $WORKING_DIR//key.json

cat $WORKING_DIR/wordpress_cloudsql.yaml.template | envsubst > $WORKING_DIR/wordpress_cloudsql.yaml

kubectl apply -f $WORKING_DIR/wordpress_cloudsql.yaml

kubectl get pod -l app=wordpress --watch

kubectl apply -f $WORKING_DIR/wordpress-service.yaml

kubectl get service -l app=wordpress --watch

