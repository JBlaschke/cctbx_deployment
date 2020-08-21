#!/usr/bin/env bash


# this () { echo $(readlink -f $(dirname ${BASH_SOURCE[0]})); }
shopt -s expand_aliases
alias this="readlink -f \$(dirname \${BASH_SOURCE[0]})"


pushd $(this)/../build

comp_str=
if [[ -n "$CC" || -n "$CXX" ]]; then
    comp_str=--compiler=conda
fi

env_str=
if [[ -n "$CFLAGS" || -n "$CXXFLAGS" ]]; then
    env_str=--use_environment_flags
fi

python ../modules/cctbx_project/libtbx/configure.py --enable_openmp_if_possible=True --enable_cuda LS49 prime iota --use_conda $comp_str $env_str
./bin/libtbx.scons -j16

popd
