#!/bin/sh
set -e

echo "Testing"
pwd
ls -l


echo "Building ..."
echo "Docker Registry : $DOCKER_REGISTRY"
echo "Docker Image Name : $DOCKER_FULL_IMAGE_NAME"

echo "$DOCKER_REGISTRY_CREDENTIALS_PSW" | docker login --username "$DOCKER_REGISTRY_CREDENTIALS_USR" --password-stdin "$DOCKER_REGISTRY"

docker build -t "$DOCKER_FULL_IMAGE_NAME" -f docker/production.Dockerfile .

docker push "$DOCKER_FULL_IMAGE_NAME"
