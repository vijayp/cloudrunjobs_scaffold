#!/bin/bash

# Copyright 2022 Google LLC
# Copyright 2023 Vijay Pandurangan
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

export PROJECT_ID=$(gcloud config get project)
export REGION=${REGION:=us-central1} # default us-central1 region if not defined

JOB_NAME=parallel-example
DOCKER_REPO=$JOB_NAME
DOCKER_IMAGE_NAME=image
NUM_TASKS=10

INPUT_FILE=input_file.txt

echo "Configure gcloud to use $REGION for Cloud Run"
gcloud config set run/region ${REGION}



echo "Enabling required services"
gcloud services enable \
    run.googleapis.com \
    cloudbuild.googleapis.com \
    containerregistry.googleapis.com

gcloud auth configure-docker


echo "setting up artifact repo"

gcloud artifacts repositories create $DOCKER_REPO --repository-format=docker \
    --location=us-west2 --description="Docker repository"


echo "Build sample into a container"
IMAGE_NAME=gcr.io/$PROJECT_ID/$DOCKER_REPO/$DOCKER_IMAGE_NAME
gcloud builds submit --tag $IMAGE_NAME


# TODO if you want to use this in the cloud, you will have to figure out how to
# get it to copy data from an input bucket appropriately, or 
# read directly from it.

# echo "Creating input bucket $INPUT_BUCKET and generating random data."
# gsutil mb $INPUT_BUCKET
# base64 /dev/urandom | head -c 100000 >${INPUT_FILE}
# gsutil cp $INPUT_FILE $INPUT_OBJECT

# Delete job if it already exists.
gcloud beta run jobs delete ${JOB_NAME} --quiet

echo "Creating ${JOB_NAME} using $IMAGE_NAME, $INPUT_OBJECT, in ${NUM_TASKS} tasks"
gcloud beta run jobs create ${JOB_NAME} --execute-now \
    --image $IMAGE_NAME \
    --tasks $NUM_TASKS \
    --set-env-vars "STORAGE_PREFIX=$PROJECT_ID"