#!/bin/bash
DIRNAME="$(dirname $(readlink -f "$0"))"
pushd ${DIRNAME}
url="${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/pipelines&status=success&ref=${CI_COMMIT_REF_NAME}"
commit=$(curl --header "PRIVATE-TOKEN: $CI_JOB_TOKEN" -s ${url} | jq -r -f jq.filter)
echo "Last green commit is '${commit}'."
echo ${commit} > .LAST_GREEN_COMMIT
popd
