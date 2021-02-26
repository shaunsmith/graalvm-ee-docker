#!/bin/sh

if [ -z ${OCI_REGION} ] || [ -z ${OCI_TENANCY} ];  then
    echo "Define OCI_REGION and OCI_TENANCY before invoking ${0}" 
    echo "E.g.,"
    echo "   export OCI_REGION=phx"
    echo "   export OCI_TENANCY=mytenancy"
    exit 1
fi

export OCI_REGION=$(echo "${OCI_REGION}" | tr '[:upper:]' '[:lower:]')
export REGISTRY=${OCI_REGION}.ocir.io/${OCI_TENANCY}/graalvm
docker images | grep ${REGISTRY} | awk '{system("docker push " $1 ":" $2 )}'
