#/bin/bash

source ./tools/config.sh

#
# CLONE/UPDATE ARDUINO
#
echo "Updating ESP32 Arduino..."
if [ ! -d "$AR_COMPS/arduino" ]; then
	git clone --branch $AR_BRANCH --single-branch $AR_REPO_URL "$AR_COMPS/arduino"
fi

if [ "$AR_BRANCH" ]; then
	echo "AR_BRANCH='$AR_BRANCH'"
	git fetch origin '$AR_BRANCH' && \
	git -C "$AR_COMPS/arduino" checkout "origin/$AR_BRANCH"
fi
if [ $? -ne 0 ]; then exit 1; fi
