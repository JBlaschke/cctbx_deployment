#!/usr/bin/env bash


set -e


#-------------------------------------------------------------------------------
# PARSE INPUTS

_skip_git=false
_overwrite_host=false
_host=""
while test $# -gt 0; do
    case "$1" in
        -h|-help)
            echo "Valid flags are:"
            echo "  1. -skip-git [default:false]"
            echo "  2. -overwrite-host"
            exit 0
            ;;
        -skip-git)
            shift
            _skip_git=true
            ;;
        -overwrite-host)
            shift
            _overwite_host=true
            _host=$1
            shift
            ;;
        *)
            echo "Error: could not parse: $1"
            exit 0
            ;;
    esac
done

if [[ $_skip_git == true ]]; then
    export SKIP_GIT=true
fi

if [[ $_overwrite_host == "true" ]]; then
    export CCTBX_HOST=$_host
else
    if [[ $NERSC_HOST == "cori" ]]; then
        export CCTBX_HOST="cori"
    else
        _hostname=$(hostname -f)
        if [[ ${_hostname#login*.} == "summit.olcf.ornl.gov" ]]; then
            # if running on login node
            export CCTBX_HOST="summit"
        elif [[ ${_hostname#batch*.} == "summit.olcf.ornl.gov" ]]; then
            # if running on interactive node
            export CCTBX_HOST="summit"
        fi
    fi
fi

#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# GIT DEPEDNTICES
#
# Update git LFS stores and update submodules. WARNING: this will clobber any
# changes to submodules that you've not yet commited
#

if [[ ! $SKIP_GIT == true ]]; then
    # Cori has a dedicated `git-lfs module`
    if [[ $CCTBX_HOST == "cori" ]]; then
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
source $project_root/opt/env/load_modules.sh -overwrite-host $CCTBX_HOST
# Conda-build settings
if [[ $CCTBX_HOST == "cori" ]]; then
    source $project_root/conda/sites/nersc.sh
fi

if [[ $CCTBX_HOST == "cgpu" ]]; then
    source $project_root/conda/sites/cgpu.sh
fi

if [[ $CCTBX_HOST == "summit" ]]; then
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
