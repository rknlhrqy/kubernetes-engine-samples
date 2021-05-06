gcloud pubsub subscriptions delete echo-read

gcloud pubsub topics delete echo

gcloud container clusters delete pubsub-test

export SA_EMAIL=$(gcloud iam service-accounts list --filter=displayName:pubsub-app --format='value(EMAIL)')

gcloud iam service-accounts delete $SA_EMAIL 

