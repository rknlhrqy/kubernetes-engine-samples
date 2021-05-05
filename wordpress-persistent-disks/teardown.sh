kubectl delete service wordpress

watch gcloud compute forwarding-rules list

kubectl delete deployment wordpress

kubectl delete pvc wordpress-volumeclaim

gcloud container clusters delete $CLUSTER_NAME --zone us-east1-b

gcloud sql instances delete $INSTANCE_NAME

gcloud projects remove-iam-policy-binding $PROJECT_ID --role roles/cloudsql.client --member serviceAccount:$SA_EMAIL

gcloud iam service-accounts delete  $SA_EMAIL
