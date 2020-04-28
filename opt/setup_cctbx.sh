#!/usr/bin/env bash


# load conda stuff
source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/env/env.sh

# get the directory of this pipeline
my_dir=$(dirname ${BASH_SOURCE[0]})
pipeline_dir=$(readlink -f $my_dir)


#
# Build CCTBX
#

export CCTBX_PREFIX=$pipeline_dir/cctbx

# build cctbx
pushd $CCTBX_PREFIX
# TODO: use Billy's new compiler wrappers, etc
python bootstrap.py hot update build --builder=dials --use-conda $CONDA_PREFIX --nproc=4
popd
