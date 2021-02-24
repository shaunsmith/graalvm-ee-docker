FROM container-registry.oracle.com/os/oraclelinux:7-slim

ARG GRAALVM_YEAR
ARG GRAALVM_VERSION
ARG JDK

ENV LANG=en_US.UTF-8 \
    GRAALVM_HOME=/usr/lib64/graalvm/graalvm${GRAALVM_YEAR}-ee-java${JDK} \
    JAVA_HOME=/usr/lib64/graalvm/graalvm${GRAALVM_YEAR}-ee-java${JDK}

COPY etc /etc/


# Other jdk11 supported options jdk, native-image, javascript, nodejs and nodejs-devel
# Other jdk8 supported options jre-headless (smallest JIT), jre, jdk, native-image, javascript, nodejs and nodejs-devel
# Add the following line with COMPONENT set to a supported value:
#   yum -y install --setopt=obsoletes=0 graalvm${GRAALVM_YEAR}-ee-${JDK}-${COMPONENT}-${GRAALVM_VERSION} && \
RUN set -xe && \
    yum update -y oraclelinux-release-el7 \
    yum install -y oraclelinux-developer-release-el7 oracle-softwarecollection-release-el7 && \
    yum-config-manager --enable ol7_developer && \
    yum-config-manager --enable ol7_developer_EPEL && \
    yum-config-manager --enable ol7_optional_latest && \
    yum install -y yum-plugin-versionlock fontconfig && \
    yum -y install --setopt=obsoletes=0 graalvm${GRAALVM_YEAR}-ee-${JDK}-jdk-${GRAALVM_VERSION} && \
    yum versionlock 'graalvm*' && \
    yum clean all && \
    fc-cache -f -v && \
    rm -rf /var/cache/yum

CMD java -version