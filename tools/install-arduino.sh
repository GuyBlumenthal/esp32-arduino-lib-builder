#/bin/bash

source ./tools/config.sh

#
# CLONE/UPDATE ARDUINO
#
echo "Updating ESP32 Arduino..."

# Determine the target branch before cloning to perform a shallow fetch
if [ -z $AR_BRANCH ]; then
    if [ -z $GITHUB_HEAD_REF ]; then
        current_branch=`git branch --show-current`
    else
        current_branch="$GITHUB_HEAD_REF"
    fi
    
    echo "Current Branch: $current_branch"
    
    # We check the remote or logic to determine the AR_BRANCH
    if [[ "$current_branch" != "master" ]]; then
        export AR_BRANCH="$current_branch"
    else
        if [ "$IDF_TAG" ]; then
            AR_BRANCH_NAME="idf-$IDF_TAG"
        elif [ "$IDF_COMMIT" ]; then
            AR_BRANCH_NAME="idf-$IDF_COMMIT"
        else
            AR_BRANCH_NAME="idf-$IDF_BRANCH"
        fi
        export AR_BRANCH="$AR_BRANCH_NAME"
    fi
fi

# Optimization: Use --depth 1 and --single-branch for maximum speed
if [ ! -d "$AR_COMPS/arduino" ]; then
    echo "Performing shallow clone of $AR_BRANCH..."
    git clone --depth 1 --branch "$AR_BRANCH" --single-branch $AR_REPO_URL "$AR_COMPS/arduino"
else
    echo "Updating existing repo to $AR_BRANCH..."
    # Fetch only the latest commit of the specific branch
    git -C "$AR_COMPS/arduino" fetch --depth 1 origin "$AR_BRANCH"
    git -C "$AR_COMPS/arduino" checkout "$AR_BRANCH"
    git -C "$AR_COMPS/arduino" reset --hard "origin/$AR_BRANCH"
fi

if [ $? -ne 0 ]; then 
    echo "Error: Failed to sync Arduino component."
    exit 1
fi
