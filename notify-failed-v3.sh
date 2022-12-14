#!/bin/bash

STAND=$1
VERSION=$2

# for LEVEL 2 deploy
sh ci-scripts/notify.sh "❌ - failed CI %0AAppname:+$APPNAME_SHORT %0AStage:+$STAND 
%0ABranch:+$CI_COMMIT_REF_SLUG%0AVersion:+$VERSION%0A%0AUser:+$GITLAB_USER_NAME"

true
