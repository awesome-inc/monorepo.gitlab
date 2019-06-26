#!/bin/bash
DIRNAME="$(dirname $(readlink -f "$0"))"
pushd ${DIRNAME}
header="PRIVATE-TOKEN: ${PRIVATE_TOKEN}"
url="${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/pipelines?status=success&ref=${CI_COMMIT_REF_NAME}"
curl --header "${header}"  -s "${url}" -o tmp
jq -r -f jq.filter < tmp > .LAST_GREEN_COMMIT
echo "Last green commit is"
cat .LAST_GREEN_COMMIT
rm tmp
popd
