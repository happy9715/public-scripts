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
    echo "tag not set current version = $CURRENT_VER"
else
    CURRENT_VER=$CI_COMMIT_TAG
    echo "tag SET current version = $CURRENT_VER"
fi

# debug string
echo "appname - $APPNAME, current_ver = $CURRENT_VER, ch_addr = $CH_ADDRESS, ch_login = $CH_LOGIN, http_header = $HTTP_HEADER_NAME"

# check exist applications
APP_EXIST_RESULT=$(echo "SELECT appname FROM cicd.appversion FINAL WHERE appname = '$APPNAME'" | curl --silen -X POST -H "$HTTP_HEADER_NAME:$HTTP_HEADER_VALUE" https://$CH_LOGIN:$CH_PASS@$CH_ADDRESS --data-binary "@-")
echo "Check status $APP_EXIST_RESULT"



if [ -z "$APP_EXIST_RESULT" ]
then
    # create new application and default  build 0
    echo "application not exist"
    echo "INSERT INTO cicd.appversion (appname, version, build_count, username) VALUES ('$APPNAME', '$CURRENT_VER', '0', '$GITLAB_USER_NAME')" | curl --silen -H "$HTTP_HEADER_NAME:$HTTP_HEADER_VALUE" -X POST  https://$CH_LOGIN:$CH_PASS@$CH_ADDRESS --data-binary "@-"
else
# check exist version 
    VERSION_RESULT=$(echo "SELECT version FROM cicd.appversion FINAL WHERE appname = '$APPNAME'  and version ='$CURRENT_VER'" | curl --silen -H "$HTTP_HEADER_NAME:$HTTP_HEADER_VALUE" -X POST  https://$CH_LOGIN:$CH_PASS@$CH_ADDRESS --data-binary "@-")
    echo "check old version result: old version = $VERSION_RESULT, current version = $CURRENT_VER "
    if [ "$VERSION_RESULT" != "$CURRENT_VER" ]
        then
            # create new version and build 0
           echo "add new version $CURRENT_VER"
           echo "INSERT INTO cicd.appversion (appname, version, build_count, username) VALUES ('$APPNAME', '$CURRENT_VER', '0', '$GITLAB_USER_NAME')" | curl --silen -H "$HTTP_HEADER_NAME:$HTTP_HEADER_VALUE" -X POST  https://$CH_LOGIN:$CH_PASS@$CH_ADDRESS --data-binary "@-"
        else
            # use current version and increment build count
            echo "version = $VERSION_RESULT"
            BUILD_COUNT_RESULT=$(echo "SELECT build_count FROM cicd.appversion FINAL WHERE appname = '$APPNAME' and version ='$VERSION_RESULT'  " | curl --silen -H "$HTTP_HEADER_NAME:$HTTP_HEADER_VALUE" -X POST  https://$CH_LOGIN:$CH_PASS@$CH_ADDRESS --data-binary "@-")
            echo "Build count = $BUILD_COUNT_RESULT"
        if [ -z "$BUILD_COUNT_RESULT" ]
            then
                echo "not up"
            else
                NEW_BUILD_COUNT=$((BUILD_COUNT_RESULT+1))
                echo "New build count = $NEW_BUILD_COUNT"
                echo "add new version $VERSION_RESULT.$NEW_BUILD_COUNT"
                echo "INSERT INTO cicd.appversion (appname, version, build_count, username) VALUES ('$APPNAME', '$VERSION_RESULT', '$NEW_BUILD_COUNT', '$GITLAB_USER_NAME')" | curl --silen -H "$HTTP_HEADER_NAME:$HTTP_HEADER_VALUE" -X POST  https://$CH_LOGIN:$CH_PASS@$CH_ADDRESS --data-binary "@-"
            fi
        fi
fi
