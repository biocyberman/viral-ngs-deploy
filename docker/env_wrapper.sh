#!/bin/bash

# This script sets up the viral-ngs environment by sourcing the
# easy-deploy script, then running whatever is passed in

export SKIP_VERSION_CHECK=true

# Gosu setup adapted from https://denibertovic.com/posts/handling-permissions-with-docker-volumes/
USER_ID=${RUN_USER_ID:-1000}
GROUP_ID=${RUN_GROUP_ID:-$USER_ID}
USER_NAME=viral-ngs-user
GROUP_NAME=ngs

echo "Starting with UID : $USER_ID, GID : $GROUP_ID"
groupadd --gid $GROUP_ID $GROUP_NAME
useradd --shell /bin/bash --uid $USER_ID --gid $GROUP_ID -o -c "" -m $USER_NAME

# Chown to deal with potential problems of creating projects under the path define in the deploy script:
# PROJECTS_PATH="$SCRIPTPATH/$CONTAINING_DIR/$PROJECTS_DIR"
export HOME=/home/$USER_NAME
ln -s /user-data $HOME/data
chown -R $USER_NAME:$GROUP_NAME /opt/viral-ngs /user-data

source /opt/viral-ngs/easy-deploy-viral-ngs.sh load
cd $HOME/data
exec /usr/local/bin/gosu $USER_NAME "$@"
