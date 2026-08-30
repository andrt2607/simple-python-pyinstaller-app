#!/bin/sh
# Build image and push to GitHub Container Registry (GHCR).
#
# Required env vars:
#   GITHUB_ACTOR  - GitHub username/owner used to log in
#   GITHUB_TOKEN  - PAT or token with write:packages scope
#
# Optional env vars:
#   IMAGE_NAME    - default: ghcr.io/andrt2607/simple-python-pyinstaller-app
#   IMAGE_TAG     - default: latest

set -eu

IMAGE_NAME="${IMAGE_NAME:-ghcr.io/andrt2607/simple-python-pyinstaller-app}"
IMAGE_TAG="${IMAGE_TAG:-latest}"

if [ -z "${GITHUB_ACTOR:-}" ] || [ -z "${GITHUB_TOKEN:-}" ]; then
    echo "GITHUB_ACTOR and GITHUB_TOKEN must be set" >&2
    exit 1
fi

echo "${GITHUB_TOKEN}" | docker login ghcr.io -u "${GITHUB_ACTOR}" --password-stdin

docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .

docker push "${IMAGE_NAME}:${IMAGE_TAG}"
