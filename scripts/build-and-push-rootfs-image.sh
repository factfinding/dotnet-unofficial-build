#!/bin/bash

set -e

MY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "$MY_DIR"/_utils.sh

: "${ARCADE_COMMIT:=e0a68f5b86f8c946197f16c5192ce81b68dfa7a2}"
: "${BUILD_TIMESTAMP:="$(date -u '+%Y%m%dT%H%M%SZ')"}"

IMAGE_TAG="$(rootfs_image_tag "$ARCADE_COMMIT" "$BUILD_TIMESTAMP")"

echo
echo "Building rootfs image to be tagged: $IMAGE_TAG"
echo

ARGS=(
    --rm
    --platform "linux/loong64"
    -t "$IMAGE_TAG"
    --build-arg ARCADE_COMMIT="$ARCADE_COMMIT"
    --build-arg BUILD_TIMESTAMP="$BUILD_TIMESTAMP"
    --ulimit nofile=2048:2048  # otherwise it can go up to ~1Gi, causing apt-get to apparently hang
    --push
    .
)

cd "$MY_DIR/../containers/rootfs"
exec docker buildx build "${ARGS[@]}"
