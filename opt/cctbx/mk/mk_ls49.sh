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


export CCTBX_INCLUDE_TIMEMORY=false
export TIMEMORY_ROOT=$CONDA_PREFIX

python ../modules/cctbx_project/libtbx/configure.py \
       --enable_openmp_if_possible=True \
       --enable_cuda \
       --use_conda $comp_str $env_str \
       LS49 prime iota

./bin/libtbx.scons -j $(nproc)

popd
