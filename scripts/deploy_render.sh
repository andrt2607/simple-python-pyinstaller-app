#!/bin/sh
# Trigger a Render deploy via its Deploy Hook URL.
#
# Required env vars:
#   RENDER_DEPLOY_HOOK - the service's Deploy Hook URL from Render dashboard

set -eu

if [ -z "${RENDER_DEPLOY_HOOK:-}" ]; then
    echo "RENDER_DEPLOY_HOOK must be set" >&2
    exit 1
fi

curl -sf -X POST "${RENDER_DEPLOY_HOOK}"
