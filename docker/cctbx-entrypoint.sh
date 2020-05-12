#!/usr/bin/env bash

# HACK: don't load the cori-specifics -- the module system will interfere with
# docker/shifter:
__old_nersc_host=$NERSC_HOST
NERSC_HOST="docker"

# Load cctbx enviromnet
source /img/opt/env.local

# restore NERSC_HOST (might be used somewhere else)
NESC_HOST=$__old_nersc_host

exec "$@"
