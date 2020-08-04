#!/usr/bin/env bash


set -e


# get the directory of this pipeline
my_dir=$(dirname ${BASH_SOURCE[0]})
opt_dir=$(readlink -f $my_dir)


source $opt_dir/activate.sh
CCTBX_INSTALL=$opt_dir/cctbx/install


libtbx.python ${CCTBX_INSTALL}/install_build.py --link
if [[ -f $CONDA_PREFIX/libtbx_env ]]; then
    rm $CONDA_PREFIX/libtbx_env
fi
libtbx.python ${CCTBX_INSTALL}/update_libtbx_env.py


# temporary fixes to the install script (these will be taken out, once they
# have been incorporated into cctbx-proper)

ln -s $opt_dir/cctbx/build/libtbx_env $CONDA_PREFIX/
rm -rf $CONDA_PREFIX/lib/python$PYVER/site-packages/boost
ln -s $opt_dir/cctbx/modules/cctbx_project/boost $CONDA_PREFIX/lib/python$PYVER/site-packages/
ln -s $opt_dir/cctbx/build/lib/pycbf.py $CONDA_PREFIX/lib/python$PYVER/site-packages/
ln -s $opt_dir/cctbx/build/lib/_pycbf.so $CONDA_PREFIX/lib/python$PYVER/site-packages/
