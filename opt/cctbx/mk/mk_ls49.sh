#!/usr/bin/env bash


# this () { echo $(readlink -f $(dirname ${BASH_SOURCE[0]})); }
shopt -s expand_aliases
alias this="readlink -f \$(dirname \${BASH_SOURCE[0]})"


pushd $(this)/../build
python ../modules/cctbx_project/libtbx/configure.py --enable_openmp_if_possible=True --enable_cuda LS49 prime iota --use_conda --use_environment_flags
./bin/libtbx.scons -j16
popd
