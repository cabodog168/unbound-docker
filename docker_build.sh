#!/bin/bash
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# currently supported platforms
TARGET_AMD64="linux/amd64"
TARGET_ARMV7="linux/arm/v7"
EXPORTER_AMD64="unbound_exporter_amd64"
EXPORTER_ARMV7="unbound_exporter_armv7"

if [ $# -ne 6 ]; then
    echo "Invalid number of arguments. Expected 6 arguments."
    exit 1
fi

if [ "$6" == "armv7" ]; then
    # build linux/amdv7 image and include armv7 version of exporter
    target=$TARGET_ARMV7
    exporter=$EXPORTER_ARMV7
else
    # No platform argument provided, default to amd64 platform
    target=$TARGET_AMD64
    exporter=$EXPORTER_AMD64
fi

echo -e "${YELLOW}Unbound version: $1${NC}"
echo -e "${YELLOW}Unbound SHA256: $2${NC}"
echo -e "${YELLOW}Unbound docker image version: $3${NC}"
echo -e "${YELLOW}OpenSSL build env version: $4${NC}"
echo -e "${YELLOW}Fresh build: $5${NC}"
echo -e "${YELLOW}Target platform: $6${NC}"

cp ./exporter/bin/$exporter ./exporter/bin/unbound_exporter
echo -e "copied $exporter to unbound_exporter"

if [ "$5" == "true" ]; then
    docker build \
    --no-cache \
    --platform "$target" \
    --build-arg UNBOUND_VERSION="$1" \
    --build-arg UNBOUND_SHA256="$2" \
    --build-arg UNBOUND_DOCKER_IMAGE_VERSION="$3" \
    --build-arg OPENSSL_BUILDENV_VERSION="$4" \
    -f unbound/release.Dockerfile \
    -t cabodog/unbound:latest \
    .
else
    docker build \
    --platform "$target" \
    --build-arg UNBOUND_VERSION="$1" \
    --build-arg UNBOUND_SHA256="$2" \
    --build-arg UNBOUND_DOCKER_IMAGE_VERSION="$3" \
    --build-arg OPENSSL_BUILDENV_VERSION="$4" \
    -f unbound/release.Dockerfile \
    -t cabodog/unbound:latest \
    .
fi

rm -f ./exporter/bin/unbound_exporter
echo -e "deleted temporary unbound_exporter"

