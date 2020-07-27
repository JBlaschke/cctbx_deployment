#!/usr/bin/env bash


set -e


#-------------------------------------------------------------------------------
# GIT DEPEDNTICES
#
# Update git LFS stores and update submodules. WARNING: this will clobber any
# changes to submodules that you've not yet commited
#

if [[ ! $SKIP_GIT == "true" ]]; then
    # Cori has a dedicated `git-lfs module`
    if [[ $NERSC_HOST == "cori" ]]; then
        module load git-lfs
    fi

    git lfs install
    git lfs pull
    git submodule update --init
fi

#-------------------------------------------------------------------------------



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


#-------------------------------------------------------------------------------
# CONDA
#
# Build miniconda and MPI4PY (linking with manually-install MPICH library above)
#

$project_root/conda/install_conda.sh

#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# CONDA XTC_BASE ENVIRONMENT
#
# Build the conda environment used by cctbx
#

$project_root/opt/env/setup_env.sh

#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# CCTBX + PSANA2
#
# Build XTC processing pipeline
#

# Build PSANA2
$project_root/opt/setup_lcls2.sh

# Build CCTBX
$project_root/opt/setup_cctbx.sh

# Create local env file
$project_root/opt/mk_env.sh

#-------------------------------------------------------------------------------
