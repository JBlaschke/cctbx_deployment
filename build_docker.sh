#!/usr/bin/env bash


set -e


# Cori has a dedicated `git-lfs module`
if [[ $NERSC_HOST == "cori" ]]; then
    module load git-lfs
fi

# git lfs install
# git lfs pull
# git submodule update --init


# use absolute paths:
project_root=$(readlink -f $(dirname ${BASH_SOURCE[0]}))

# point this to the "right" cctbx revision
export CCTBX_REV=3d67a720f474f44c4843ff2f6807c0b1254eab15

docker build                                 \
    -t cctbx                                 \
    --build-arg CCTBX_REV                    \
    -f $project_root/docker/Dockerfile.cctbx \
    $project_root 
