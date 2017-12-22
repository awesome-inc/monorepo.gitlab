#!/bin/bash
DIRNAME="$(dirname $(readlink -f "$0"))"
pushd ${DIRNAME}
url="${CI_SERVER_URL}/api/v4/projects/${CI_PROJECT_ID}/pipelines?private_token=${PRIVATE_TOKEN}&status=success&ref=${CI_COMMIT_REF_NAME}"
commit=$(curl -s ${url} | jq -r -f jq.filter)
echo "Last green commit is '${commit}'."
echo ${commit} > .LAST_GREEN_COMMIT
popd
