#!/usr/bin/env bash


# stop when there's an error
set -e


# # load site-specific variables: XTC_**
# source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/env/vars.sh


# load conda stuff
source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/env/env.sh


# # ensure that the lcls2 submodule is all there
# git submodule update --init --recursive


# get the directory of this pipeline
my_dir=$(dirname ${BASH_SOURCE[0]})
pipeline_dir=$(readlink -f $my_dir)


# generate a local env
LCLS2_DIR="$pipeline_dir/lcls2"
CCTBX_PREFIX="$pipeline_dir/cctbx"

cat > $pipeline_dir/env/env.local <<EOF
#
# update PATH (this is local to the current machine)
# Automaticall generated using setup_xtc.sh
#


# load site-specific variables: XTC_**
source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/env/vars.sh


# load environment
source $pipeline_dir/env/env.sh


# variables needed to run psana
export LCLS2_DIR="$LCLS2_DIR"
export __LCLS2_PATHSTR="$LCLS2_DIR/install/bin"
export __LCLS2_PYTHONPATHSTR="$LCLS2_DIR/install/lib/python$PYVER/site-packages"
if [[ -d \$__LCLS2_PATHSTR ]]; then
    if [[ ":\$PATH:" != *\$__LCLS2_PATHSTR* ]]; then
        export PATH="\$PATH:\$__LCLS2_PATHSTR"
    fi
    if [[ ":\$PYTHONPATH:" != *\$__LCLS2_PYTHONPATHSTR* ]]; then
        export PYTHONPATH="\$PYTHONPATH:\$__LCLS2_PYTHONPATHSTR"
    fi
fi


# variables needed to run CCTBX
export CCTBX_PREFIX="$CCTBX_PREFIX"
if [[ -e \$CCTBX_PREFIX/build/setpaths.sh ]]; then
    source \$CCTBX_PREFIX/build/setpaths.sh
fi
EOF
