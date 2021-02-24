ARG DOCKER_USER
ARG GRAALVM_VERSION
ARG JDK

FROM ${DOCKER_USER}/enterprise-${JDK}:native-image-${GRAALVM_VERSION} 

ARG RUNTIME_ROOT

COPY ${RUNTIME_ROOT}/src/main/c/libfnunixsocket.so /function/runtime/lib/