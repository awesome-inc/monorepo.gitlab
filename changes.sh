#!/bin/bash
folder=${1}
DIRNAME="$(dirname $(readlink -f "$0"))"
ref=$(cat "${DIRNAME}/.LAST_GREEN_COMMIT") 
ref=${ref:-HEAD~}

echo "Checking for changes of folder '${folder}' from ref '${ref}'..."

git diff ${ref} --name-only | grep -qw "^${folder}"
changes=$?
if [[ ${changes} -eq 0 ]]; then
  echo "Folder '${folder}' has changed."
else
  echo "Folder '${folder}' has not changed."
fi
exit ${changes}
