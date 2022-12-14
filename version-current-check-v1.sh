#!/bin/bash
# v1.0.0

# INPUT VIARBALES
APPNAME=$1
CURRENT_VER=$2
CH_ADDRESS=$3
CH_LOGIN=$4
CH_PASS=$5
HTTP_HEADER_NAME=$6
HTTP_HEADER_VALUE=$7


if [ -z "$CI_COMMIT_TAG" ]
then
    CURRENT_VER=$2
# debug string
#    echo "tag not set current version = $CURRENT_VER"
else
    CURRENT_VER=$CI_COMMIT_TAG
# debug string
#    echo "tag SET current version = $CURRENT_VER"
fi

# debug string
#echo "appname - $APPNAME, current_ver = $CURRENT_VER, ch_addr = $CH_ADDRESS, ch_login = $CH_LOGIN, http_header = $HTTP_HEADER_NAME"

CURRENT_VERSION_OUTPUT=$(echo "SELECT version FROM cicd.appversion FINAL WHERE appname = '$APPNAME'  and version ='$CURRENT_VER'" | curl --silen -H "$HTTP_HEADER_NAME:$HTTP_HEADER_VALUE" -X POST  https://$CH_LOGIN:$CH_PASS@$CH_ADDRESS --data-binary "@-")
# debug only
#echo "version $CURRENT_VERSION_OUTPUT"

CURRENT_BUILD_OUTPUT=$(echo "SELECT build_count FROM cicd.appversion FINAL WHERE appname = '$APPNAME'  and version ='$CURRENT_VER'" | curl --silen -H "$HTTP_HEADER_NAME:$HTTP_HEADER_VALUE" -X POST  https://$CH_LOGIN:$CH_PASS@$CH_ADDRESS --data-binary "@-")
# debug only
##echo "build $CURRENT_BUILD_OUTPUT"


FULL_VERSION_RESULT="$CURRENT_VERSION_OUTPUT.$CURRENT_BUILD_OUTPUT"
echo $FULL_VERSION_RESULT