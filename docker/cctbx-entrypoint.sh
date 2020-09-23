#!/usr/bin/env bash

# HACK: don't load the cori-specifics -- the module system will interfere with
# docker/shifter:
__old_nersc_host=$NERSC_HOST
NERSC_HOST="docker"

# Load cctbx enviromnet
source /img/opt/activate.sh -cctbx-setpaths

# restore NERSC_HOST (might be used somewhere else)
NERSC_HOST=$__old_nersc_host

exec "$@"
