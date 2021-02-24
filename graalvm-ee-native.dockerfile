ARG DOCKER_USER
ARG GRAALVM_VERSION
ARG JDK

FROM ${DOCKER_USER}/enterprise-${JDK}:jdk-${GRAALVM_VERSION} 

# Redeclare because FROM creates a new build stage
ARG GRAALVM_YEAR="21"
ARG GRAALVM_VERSION
ARG JDK

RUN set -xe && \
    yum -y install --setopt=obsoletes=0 graalvm${GRAALVM_YEAR}-ee-${JDK}-native-image-${GRAALVM_VERSION} && \
    yum versionlock 'graalvm*' && \
    yum clean all && \
    fc-cache -f -v && \
    rm -rf /var/cache/yum
