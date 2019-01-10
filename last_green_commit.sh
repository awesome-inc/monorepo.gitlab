#!/bin/bash
DIRNAME="$(dirname $(readlink -f "$0"))"
pushd ${DIRNAME}
# https://gitlab.com/api/v4
api_url=${CI_API_V4_URL:-${CI_SERVER_URL}/api/v4}
token=${CI_JOB_TOKEN:-${PRIVATE_TOKEN}}
url="${api_url}/projects/${CI_PROJECT_ID}/pipelines?private_token=${token}&status=success&ref=${CI_COMMIT_REF_NAME}"
commit=$(curl -s ${url} | jq -r -f jq.filter)
echo "Last green commit is '${commit}'."
echo ${commit} > .LAST_GREEN_COMMIT
popd
