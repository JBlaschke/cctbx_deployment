#!/usr/bin/env bash


# use absolute paths:
project_root=$(readlink -f $(dirname ${BASH_SOURCE[0]}))


#-------------------------------------------------------------------------------
# COMPATIBILITY WITH SITES
#
# This will load any site-specific settings
#

# Module files
source $project_root/opt/env/load_modules.sh
# Conda-build settings
if [[ $NERSC_HOST == "cori" ]]; then
    source $project_root/conda/sites/nersc.sh
fi

_hostname=$(hostname -f)
if [[ ${_hostname#login*.} == "summit.olcf.ornl.gov" ]]; then
    source $project_root/conda/sites/olcf.sh
fi

#-------------------------------------------------------------------------------
