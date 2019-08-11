#!/bin/bash
set -e

echo "Deploying script ... "

echo "Image Name : [$DOCKER_IMAGE]"
echo "Image tag : [$DOCKER_VERSION]"
echo "Not Jenkins Url : [$NOT_JENKINS_URL]"

payload="{\"version\":\"$DOCKER_VERSION\",\"imageName\":\"$DOCKER_IMAGE\"}"

sign(){
    sign=$(echo -n "$payload" | openssl sha1 -hmac "$NOT_JENKINS_SECRET")
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
