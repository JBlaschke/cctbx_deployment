#!/usr/bin/env bash

# this () { echo $(readlink -f $(dirname ${BASH_SOURCE[0]})); }
shopt -s expand_aliases
alias this="readlink -f \$(dirname \${BASH_SOURCE[0]})"



export CCTBX_PREFIX=$(this)/cctbx
pushd $CCTBX_PREFIX
rm bootstrap.py
wget "https://raw.githubusercontent.com/cctbx/cctbx_project/master/libtbx/auto_build/bootstrap.py"
popd
