#!/bin/bash

# This file must be sourced in order to set the proper bash environment variables that
# are use by heketi-cli
# Also we create a few funtions that can be called straight from the bash cli

# Unset Variables
# Since there are 2 GlusterFS clusters (app & infra), we need to know which one we set
unset HEKETI_CLI_SERVER
unset HEKETI_CLI_KEY

# Export Variables for App GlusterFS Cluster
export HEKETI_CLI_SERVER=http://heketi-storage.glusterfs.svc.cluster.local:8080
export HEKETI_CLI_KEY=$(oc export secret heketi-storage-admin-secret --namespace=glusterfs |grep key |awk '{print $2}' |base64 -d)
export HEKETI_CLI_USER=admin
export HEKETI_CLI_BIN=/usr/bin/heketi-cli

function cluster_list {
  $HEKETI_CLI_BIN --user=$HEKETI_CLI_USER --secret=$HEKETI_CLI_KEY --server=$HEKETI_CLI_SERVER cluster list
}
function topology_info {
  $HEKETI_CLI_BIN --user=$HEKETI_CLI_USER --secret=$HEKETI_CLI_KEY --server=$HEKETI_CLI_SERVER topology info
}
function volume_list {
  $HEKETI_CLI_BIN --user=$HEKETI_CLI_USER --secret=$HEKETI_CLI_KEY --server=$HEKETI_CLI_SERVER volume list
}
function blockvolume_list {
  $HEKETI_CLI_BIN --user=$HEKETI_CLI_USER --secret=$HEKETI_CLI_KEY --server=$HEKETI_CLI_SERVER blockvolume list
}
