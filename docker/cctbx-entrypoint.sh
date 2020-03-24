#!/usr/bin/env bash

# Because of the way that env.local (and its dependencies) are designed, we need
# CWD to be /opt/pipelines/xtc_process <= might be fixed later
pushd /opt/pipelines/xtc_process >> /dev/null

# HACK: don't load the cori-specifics (the module system will interfere with
# docker/shifter:
__old_nersc_host=NERSC_HOST
NERSC_HOST="docker"

# Load cctbx enviromnet
source env.local 

# restore NERSC_HOST (might be used somewhere else)
NESC_HOST=__old_nersc_host

# go back
popd >> /dev/null

exec "$@"
