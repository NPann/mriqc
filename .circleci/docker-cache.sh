#!/bin/bash
#
# Docker cache script
#
#

# Setting      # $ help set
set -e         # Exit immediately if a command exits with a non-zero status.
set -u         # Treat unset variables as an error when substituting.
set -x         # Print command traces before executing command.

DOCKER_ROOT_DIR="/var/lib/docker"
DOCKER_VOLUMES="${DOCKER_ROOT_DIR}/btrfs/subvolumes"

mkdir -p /home/ubuntu/btrfs
for layerpath in $( ls -F ${DOCKER_VOLUMES} | grep / ); do
	layerid=$( basename $layerpath )
	echo "Caching layer $layerid"
	# Cache this layer
	btrfs subvolume snapshot -r ${DOCKER_VOLUMES}/$layerpath /home/ubuntu/btrfs/$layerid 
	sudo btrfs send /home/ubuntu/btrfs/$layerid | gzip -9 > ${DOCKER_CACHE_DIR}/$layerid.gz
done
