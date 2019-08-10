#!/bin/bash
set -e

echo "Deploying script ... "

#FULL_NAME="$DOCKER_RE0i#GISTRY"/"$DOCKER_IMAGE_NAME":"$BUILD_VERSION"

echo "$DOCKER_REGISTRY"
echo "$DOCKER_IMAGE_NAME"
echo "$VERSION"
echo "$FULL_NAME"

payload="{\"version\":\"$VERSION\",\"imageName\":\"$FULL_NAME\"}"

sign(){
    sign=$(echo -n "$payload" | openssl sha1 -hmac "$SECRET")
    if [ ${#sign} == 49 ]; then
        sign=${sign#"(stdin)= "}
    fi
    echo "$sign"
}

makeCurl(){
    echo "Curling : $NOT_JENKINS_URL"
    echo "Payload : $payload"

    while read data; do
        echo "Signature : $data"
        curl --silent --show-error --fail \
        -H "Content-type: application/json" \
        -H "user-agent: Post-Hookshot" \
        -H "x-hub-signature: sha1=$data" \
        -X POST -d "$payload" \
        "$NOT_JENKINS_URL"
    done
}

sign | makeCurl
exit
