#!/bin/bash
url=${CI_SERVER_URL}/api/v4/projects/${CI_PROJECT_ID}/pipelines?private_token=${PRIVATE_TOKEN}
DIRNAME="$(dirname $(readlink -f "$0"))"
pushd ${DIRNAME}
curl -s ${url} | jq -r -f jq.filter > .LAST_GREEN_COMMIT
popd
