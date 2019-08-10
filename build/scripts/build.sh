#!/bin/sh
set -e

echo "Building script ..."
echo "Docker Registry : $DOCKER_REGISTRY"
echo "Docker Image Name : $DOCKER_FULL_IMAGE_NAME"

echo "$DOCKER_REGISTRY_CREDENTIALS_PSW" | docker login --username "$DOCKER_REGISTRY_CREDENTIALS_USR" --password-stdin "$DOCKER_REGISTRY"

cd "$GIT_CLONE_DIRECTORY"

docker build -t "$DOCKER_FULL_IMAGE_NAME" -f docker/production.Dockerfile .

docker push "$DOCKER_FULL_IMAGE_NAME"
