#!/bin/bash
export PROJECT='mmpyro-snadbox'
export SERVICE_ACCOUNT_KEY='secret.json'
export BUCKET_LOCATION='europe-west3'
export ACCOUNT='mmk8s-cluster'
export SERVICE_ACCOUNT_NAME='spinnaker-gcs-account'

if [[ -n $1 ]] && [[ "$1" == "login" ]]
then
    gcloud auth activate-service-account --key-file ./secret.json
    gcloud config set project ${PROJECT}
    exit 0
fi

gcloud container clusters get-credentials ${ACCOUNT} --zone europe-west3-c --project ${PROJECT}
kubectl config use-context 'gke_mmpyro-snadbox_europe-west3-c_mmk8s-cluster'
TOKEN='7419db034d6e6f3cfd4041c5bad640b0d222e90c'
echo ${TOKEN} > token

kubectl apply -f ./account.yml
hal config version edit --version 1.19.6
hal config provider kubernetes enable
CONTEXT=$(kubectl config current-context)


hal config provider kubernetes account add ${ACCOUNT} \
    --provider-version v2 \
    --context ${CONTEXT}
hal config features edit --artifacts true
# hal config features edit --artifacts-rewrite true

hal config storage gcs edit --project ${PROJECT} \
    --bucket-location ${BUCKET_LOCATION} \
    --json-path ${SERVICE_ACCOUNT_KEY}
hal config storage edit --type gcs


hal config provider docker-registry enable
hal config provider docker-registry account add gcr \
 --address gcr.io \
 --username _json_key \
 --password-file secret.json

hal config artifact github enable
hal config artifact github account add 'mmpyro' --token-file ./token

hal config deploy edit --type distributed --account-name ${ACCOUNT}
hal deploy apply
# hal version list
# hal deploy apply

# to connect use:
# hal deploy connect
# localhost:9000

