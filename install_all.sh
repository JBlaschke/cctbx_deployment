#!/usr/bin/env bash


set -e


git submodule update --init


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
if [[ $NERSC_HOST = "cori" ]]; then
    source $project_root/conda/sites/nersc.sh
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
