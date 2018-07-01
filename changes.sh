#!/bin/bash
folder=${1}
DIRNAME="$(dirname $(readlink -f "$0"))"
ref=$(cat "${DIRNAME}/.LAST_GREEN_COMMIT") 
# Always indicate changes unless valid green commit ref given, #1
if [[ ! ${ref:+1} ]]; then 
  echo 'No LAST_GREEN_COMMIT. Assuming changes.'
  exit 0
fi

echo "Checking for changes of folder '${folder}' from ref '${ref}'..."

git diff ${ref} --name-only >/dev/null
if [[ $? -ne 0 ]]; then
  echo "Git error. Assuming changes."
  exit 0
fi

git diff ${ref} --name-only | grep -qw "^${folder}"
changes=$?
if [[ ${changes} -eq 0 ]]; then
  echo "Folder '${folder}' has changed."
else
  echo "Folder '${folder}' has not changed."
fi
exit ${changes}
