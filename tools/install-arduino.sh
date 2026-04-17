#/bin/bash

source ./tools/config.sh

#
# CLONE/UPDATE ARDUINO
#
echo "Updating ESP32 Arduino..."

# Path to the specific component
ARDUINO_PATH="$AR_COMPS/arduino"

if [ ! -d "$ARDUINO_PATH" ]; then
    # Clone for the first time
    git clone --depth 1 --branch "$AR_BRANCH" --single-branch "$AR_REPO_URL" "$ARDUINO_PATH"
else
    # Update existing directory
    echo "Updating existing clone at $AR_BRANCH..."
    git -C "$ARDUINO_PATH" fetch origin "$AR_BRANCH" --depth 1
    git -C "$ARDUINO_PATH" checkout FETCH_HEAD
fi
