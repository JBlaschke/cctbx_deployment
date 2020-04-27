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

cat > $pipeline_dir/env.local <<EOF
#
# update PATH (this is local to the current machine)
# Automaticall generated using setup_xtc.sh
#


# load site-specific variables: XTC_**
source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/env/vars.sh


# load environment
source $pipeline_dir/env/env.sh


# variables needed to run psana
export LCLS2_DIR="$pipeline_dir/lcls2"
if [[ -e \$LCLS2_DIR/setup_env.sh ]]; then
    export PATH="\$LCLS2_DIR/install/bin:\$PATH"
    export PYTHONPATH="\$LCLS2_DIR/install/lib/python\$PYVER/site-packages:\$PYTHONPATH"
fi


# variables needed to run CCTBX
export CCTBX_PREFIX=$pipeline_dir/cctbx
if [[ -e \$CCTBX_PREFIX/build/setpaths.sh ]]; then
    source \$CCTBX_PREFIX/build/setpaths.sh
fi
EOF

