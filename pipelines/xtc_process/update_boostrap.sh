#!/usr/bin/env bash

# get the directory of this pipeline
my_dir=$(dirname ${BASH_SOURCE[0]})
pipeline_dir=$(readlink -f $my_dir)

export CCTBX_PREFIX=$pipeline_dir/cctbx
pushd $CCTBX_PREFIX
rm bootstrap.py
wget "https://raw.githubusercontent.com/cctbx/cctbx_project/master/libtbx/auto_build/bootstrap.py"
popd
