gcloud config set project rknlhrqy

gcloud config set compute/zone us-east1-b

gcloud services enable cloudresourcemanager.googleapis.com pubsub.googleapis.com

gcloud container clusters create pubsub-test

gcloud pubsub topics create echo

gcloud pubsub subscriptions create echo-read --topic=echo


gcloud iam service-accounts create pubsub-app --display-name pubsub-app

export SA_EMAIL=$(gcloud iam service-accounts list --filter=displayName:pubsub-app --format='value(EMAIL)')

gcloud projects add-iam-policy-binding rknlhrqy --role roles/pubsub.subscriber --member serviceAccount:$SA_EMAIL

gcloud iam service-accounts keys create ./key.json --iam-account $SA_EMAIL

kubectl create secret generic pubsub-key --from-file=key.json=./key.json


kubectl apply -f ./deployment/pubsub-with-secret.yaml

kubectl get pods -l app=pubsub
