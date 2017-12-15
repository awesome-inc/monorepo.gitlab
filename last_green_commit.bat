@echo off
setlocal
set url=%CI_SERVER_URL%/api/v4/projects/%CI_PROJECT_ID%/pipelines?private_token=%PRIVATE_TOKEN%
pushd %~dp0
curl -s %url% | jq -r -f jq.filter
popd
endlocal