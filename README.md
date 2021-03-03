# GraalVM Enterprise Images for Oracle Cloud Infrastructure and Functions

This repo contains Dockerfile definitions and scripts to build Docker
container images for GraalVM Enterprise on an OCI VM using RPMs from
the OCI yum repo, including an `init-image` to generate an Fn function
based on GraalVM Enterprise Native Image.

# Usage

1. Scripts must be run on an OCI Linux VM
2. Define environment variables required by the build script, e.g.:
```shell
   export GRAALVM_VERSION=21.0.0.2
   export FN_FDK_VERSION=1.0.123
   export OCI_REGION=phx
   export OCI_TENANCY=mytenancy
```
NOTE: `OCI_REGION` needs to be set to the region your VM is located in for yum access to work.

3. Run `build.sh`

# Output

A collection of container images are generated with support for both JDK 8 and 11.

## Fn Init Image

Used to generate a Java function template that will be compiled ahead-of-time
with GraalVM Enterprise Native Image.

**JDK 8**:  `<OCI_REGION>.ocir.io/<OCI_TENANCY>/graalvm/fn-java-native-init:<FN_FDK_VERSION>-ee-<GRAALVM_VERSION>`

**JDK 11**: `<OCI_REGION>.ocir.io/<OCI_TENANCY>/graalvm/fn-java-native-init:jdk11-<FN_FDK_VERSION>-ee-<GRAALVM_VERSION>`

## Fn Native Image Build

An image that extends the GraalVM Enterprise Native Image image to 
add the Unix Domain Socket library needed by the Fn FDK.

**JDK 8**:  `<OCI_REGION>.ocir.io/<OCI_TENANCY>/graalvm/fn-java-native:<FN_FDK_VERSION>-ee-<GRAALVM_VERSION>`

**JDK 11**: `<OCI_REGION>.ocir.io/<OCI_TENANCY>/graalvm/fn-java-native:jdk11-<FN_FDK_VERSION>-ee-<GRAALVM_VERSION>`

## GraalVM Enterprise JDK

Oracle Linux with GraalVM Enterprise JDK installed.

**JDK 8**: `<OCI_REGION>.ocir.io/<OCI_TENANCY>/graalvm/enterprise-8:jdk-<GRAALVM_VERSION>`  

**JDK 11**: `<OCI_REGION>.ocir.io/<OCI_TENANCY>/graalvm/enterprise-11:jdk-<GRAALVM_VERSION>`

## GraalVM Enterprise Native Image

Oracle Linux image that extends the GraalVM Enterprise JDK by adding
the `native-image` utility.

**JDK 8** `<OCI_REGION>.ocir.io/<OCI_TENANCY>/graalvm/enterprise-8:native-image-<GRAALVM_VERSION>`

**JDK 11**: `<OCI_REGION>.ocir.io/<OCI_TENANCY>/graalvm/enterprise-11:native-image-<GRAALVM_VERSION>`




