#!/bin/bash
# v1.0.0

# INPUT VIARBALES
APPNAME=$1
CH_ADDRESS=$2
CH_LOGIN=$3
CH_PASS=$4
HTTP_HEADER_NAME=$5
HTTP_HEADER_VALUE=$6

### for brnahc
BRANCH=$CI_COMMIT_BRANCH

# debug string
#echo "appname - $APPNAME, branch = $BRANCH, ch_addr = $CH_ADDRESS, ch_login = $CH_LOGIN, http_header = $HTTP_HEADER_NAME"

echo "insert string"
echo "INSERT INTO cicd.commits (appname, branch, hash, user) VALUES ('$APPNAME', '$BRANCH', '$CI_COMMIT_SHORT_SHA', '$GITLAB_USER_NAME')" | curl --silen -H "$HTTP_HEADER_NAME:$HTTP_HEADER_VALUE" -X POST  https://$CH_LOGIN:$CH_PASS@$CH_ADDRESS --data-binary "@-"
