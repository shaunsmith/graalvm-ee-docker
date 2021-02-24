#!/bin/sh
set -ex

if [ -z ${GRAALVM_VERSION} ] || [ -z ${FN_FDK_VERSION} ];  then
    echo "Define GRAALVM_VERSION and FN_FDK_VERSION before invoking ${0}" 
    echo "E.g.,"
    echo "export GRAALVM_VERSION=21.0.0.2"
    echo "export FN_FDK_VERSION=1.0.123"
    exit 1
fi

export GRAALVM_EDITION="graalvm-ee"
export DOCKER_USER=${DOCKER_USER:-"graalvm"}
version_elemements=(${GRAALVM_VERSION//./ })
export GRAALVM_YEAR="${version_elemements[0]}"

# Build the GraalVM JDK images
docker build -f graalvm-ee-jdk.dockerfile \
    --build-arg GRAALVM_YEAR=${GRAALVM_YEAR} \
    --build-arg GRAALVM_VERSION=${GRAALVM_VERSION} \
    --build-arg JDK="8" \
    -t ${DOCKER_USER}/enterprise-8:jdk-${GRAALVM_VERSION} .

docker build -f graalvm-ee-jdk.dockerfile \
    --build-arg GRAALVM_YEAR=${GRAALVM_YEAR} \
    --build-arg GRAALVM_VERSION=${GRAALVM_VERSION} \
    --build-arg JDK="11" \
    -t ${DOCKER_USER}/enterprise-11:jdk-${GRAALVM_VERSION} .

# Build the GraalVM Native Image images
docker build -f graalvm-ee-native.dockerfile \
    --build-arg DOCKER_USER=${DOCKER_USER} \
    --build-arg GRAALVM_YEAR=${GRAALVM_YEAR} \
    --build-arg GRAALVM_VERSION=${GRAALVM_VERSION} \
    --build-arg JDK="8" \
    -t ${DOCKER_USER}/enterprise-8:native-image-${GRAALVM_VERSION} .

docker build -f graalvm-ee-native.dockerfile \
    --build-arg DOCKER_USER=${DOCKER_USER} \
    --build-arg GRAALVM_YEAR=${GRAALVM_YEAR} \
    --build-arg GRAALVM_VERSION=${GRAALVM_VERSION} \
    --build-arg JDK="11" \
    -t ${DOCKER_USER}/enterprise-11:native-image-${GRAALVM_VERSION} .

#
# Build the Fn native image init images for Java 8 and 11
#

fdk_root="fdk-java-master"

# If necessary, download and unzip latest Fn Java fdk_root sources
if [ ! -d "${fdk_root}" ]; then
    wget https://github.com/fnproject/fdk-java/archive/master.zip
    unzip master.zip
fi

# If necessary, build the unix socket library that will be included in the build images
if [ ! -f ${fdk_root}/runtime/src/main/c/libfnunixsocket.so ]; then
    ${fdk_root}/runtime/src/main/c/rebuild_so.sh
fi



# Build the Fn Native Image image with socket library
docker build -f graalvm-ee-fn.dockerfile \
    --build-arg DOCKER_USER=${DOCKER_USER} \
    --build-arg GRAALVM_VERSION=${GRAALVM_VERSION} \
    --build-arg JDK="8" \
    --build-arg RUNTIME_ROOT=${fdk_root}/runtime \
    -t ${DOCKER_USER}/fn-java-native:${FN_FDK_VERSION}-${GRAALVM_EDITION}-${GRAALVM_VERSION} .

docker build -f graalvm-ee-fn.dockerfile \
    --build-arg DOCKER_USER=${DOCKER_USER} \
    --build-arg GRAALVM_VERSION=${GRAALVM_VERSION} \
    --build-arg JDK="11" \
    --build-arg RUNTIME_ROOT=${fdk_root}/runtime \
    -t ${DOCKER_USER}/fn-java-native:jdk11-${FN_FDK_VERSION}-${GRAALVM_EDITION}-${GRAALVM_VERSION} .

# Run the Fn FDK's native init image creation script
cd native-image-fn-init
export BUILD_VERSION=${FN_FDK_VERSION}
./docker-build.sh

