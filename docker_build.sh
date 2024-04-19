#!/bin/bash
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# currently supported platforms
TARGET_AMD64="linux/amd64"
TARGET_ARMV7="linux/arm/v7"
EXPORTER_AMD64="unbound_exporter_amd64"
EXPORTER_ARMV7="unbound_exporter_armv7"

if [ $# -lt 4 ] && [ $# -gt 5 ]; then
    echo "Invalid number of parameters. Expected 4 or 5 arguments."
    exit 1
fi

if [ $# -eq 5 ]; then
    case "$5" in
        "amd64")
            # build linux/amd64 image and include amd64 version of exporter
            target=$TARGET_AMD64
            exporter=$EXPORTER_AMD64
            ;;
        "armv7")
            # build linux/amdv7 image and include armv7 version of exporter
            target=$TARGET_ARMV7
            exporter=$EXPORTER_ARMV7
            ;;
        *)
            # anyting else default to amd64 platform
            target=$TARGET_AMD64
            exporter=$EXPORTER_AMD64
            ;;
    esac
else
    # No platform argument provided, default to amd64 platform
    target=$TARGET_AMD64
    exporter=$EXPORTER_AMD64
fi

echo -e "${YELLOW}Unbound version: $1${NC}"
echo -e "${YELLOW}Unbound SHA256: $2${NC}"
echo -e "${YELLOW}Unbound docker image version: $3${NC}"
echo -e "${YELLOW}OpenSSL build env version: $4${NC}"
echo -e "${YELLOW}Platform: $target${NC}"

cp ./exporter/bin/$exporter ./exporter/bin/unbound_exporter
echo -e "copied $exporter to unbound_exporter"

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

rm -f ./exporter/bin/unbound_exporter
echo -e "deleted temporary unbound_exporter"

