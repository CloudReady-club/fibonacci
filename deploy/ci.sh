#!/bin/bash
RUN_BUILD=1
RUN_PACKAGING=1
RUND_DEPLOY=1

DONET_SOURCE_FOLDER="../dotnet-api/dotnet-fibonacci-webapp"
GOLANG_SOURCE_FOLDER="../go-container/"
PAYTHON_SOURCE_FOLDER="../python-api/"

DOCKER_HUB_ORGANISATION="cloudreadyclub"
DOCKER_IMAGE_VERSION="2.2"

K8S_DOTNET_NAMESAPCE="fibonacci"
K8S_GOLANG_NAMESAPCE="fibonacci"
K8S_PYTHON_NAMESAPCE="fibonacci"
K8S_DOTNET_AOT_NAMESAPCE="fibonacci"


GO_IMAGE=${DOCKER_HUB_ORGANISATION}/go-fibonacci:${DOCKER_IMAGE_VERSION}
DONET_IMAGE=${DOCKER_HUB_ORGANISATION}/dotnet-fibonacci:${DOCKER_IMAGE_VERSION}
DONET_AOT_IMAGE=${DOCKER_HUB_ORGANISATION}/dotnet-aot-fibonacci:${DOCKER_IMAGE_VERSION}
PYTHON_IMAGE=${DOCKER_HUB_ORGANISATION}/python-fibonacci:${DOCKER_IMAGE_VERSION}

build_and_deploy(){
    
    SOURCE_FOLDER=$1
    K8S_NAMESAPCE=$2
    DOCKERFILE=$3
    IMAGE_NAME=$4
    TEMPLATE_PREFIX=$5

    if [ $RUN_BUILD -eq "1" ];then 
        echo "building docker images"
        docker build -f ${SOURCE_FOLDER}/${DOCKERFILE} -t ${IMAGE_NAME} ${SOURCE_FOLDER} \
                --label "repo=cloudreadyclub"
        
    fi 

    if [ $RUN_PACKAGING -eq "1" ];then 
        echo "configuring k8s manifest files"
        yq eval ".spec.template.spec.containers[0].image = \"$IMAGE_NAME\"" ${TEMPLATE_PREFIX}.deploy.source.yaml > ./${TEMPLATE_PREFIX}.deploy/deploy.yaml
    fi   
    

    if [ $RUND_DEPLOY -eq "1" ];then 
        
        echo "CREATE $K8S_NAMESAPCE namespace if doesn't exist"
        K8S_NAMESAPCE_EXIST=$(kubectl get ns $K8S_NAMESAPCE | wc -l)
        if [ $K8S_NAMESAPCE_EXIST -eq "0" ]; then
            kubectl create ns $K8S_NAMESAPCE
        fi
        
        echo "Deploy worloads"
        kubectl -n $K8S_NAMESAPCE apply -f ${TEMPLATE_PREFIX}.deploy/.
    fi



}
echo "#########################Deploying dotnet worloads ###########################"
build_and_deploy  $DONET_SOURCE_FOLDER $K8S_DOTNET_NAMESAPCE "dockerfile" $DONET_IMAGE "dotnet"
echo "#########################Deploying go worloads ###########################"
build_and_deploy  $GOLANG_SOURCE_FOLDER $K8S_GOLANG_NAMESAPCE "dockerfile" $GO_IMAGE "go"
echo "#########################Deploying dotnet.aot worloads ###########################"
build_and_deploy  $DONET_SOURCE_FOLDER $K8S_DOTNET_AOT_NAMESAPCE "dockerfile.aot" $DONET_AOT_IMAGE "dotnet.aot"
echo "#########################Deploying python worloads ###########################"
build_and_deploy  $PAYTHON_SOURCE_FOLDER $K8S_PYTHON_NAMESAPCE "dockerfile" $PYTHON_IMAGE "python"






