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

# extract static resources
pushd $CCTBX_PREFIX/modules
for name in *.gz
do
    tar -xvf $name
done
for name in *.zip
do
    unzip $name
done

scons_name=$(find . -maxdepth 1 -name "scons*" -type d)
mv $scons_name scons
popd


# build cctbx
pushd $CCTBX_PREFIX
# TODO: use Billy's new compiler wrappers, etc
python bootstrap.py build --builder=dials --use-conda $CONDA_PREFIX --nproc=4 --config-flags="--enable_openmp_if_possible=True"
popd
