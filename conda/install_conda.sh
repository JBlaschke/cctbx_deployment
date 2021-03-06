#!/usr/bin/env bash


# stop running if there's an error
set -e


#
# Run conda installer locally
#

# set up install path for the local conda path
conda_setup_path=$(readlink -f $(dirname ${BASH_SOURCE[0]}))
conda_prefix=$conda_setup_path/miniconda3

# run conda installer
if [[ $USE_PPC == true ]]; then
    $conda_setup_path/Miniconda3-latest-Linux-ppc64le.sh -b -p $conda_prefix
else
    $conda_setup_path/Miniconda3-latest-Linux-x86_64.sh -b -p $conda_prefix
fi


#
# update PATH (this is local to the current machine)
#

cat > $conda_setup_path/env.local <<EOF
#
# Add the local miniconda install to the PATH
# Automaticall generated using install_conda.sh
#


if [[ ":\$PATH:" != *$conda_prefix/bin* ]]; then
    export PATH=$conda_prefix/bin:\$PATH
    # Sometimes junk can be left over in the PYTHONPATH variable => delete it
    export PYTHONPATH=
fi
# used by unenv.sh
export PATHSTR=$conda_prefix/bin
export CONDABIN=$conda_prefix/condabin
EOF


#
# This conda install could be outdated => run update
#

source $conda_setup_path/env.local
conda update -y --all -n base -c defaults conda

#
# Create a Python 3.6 base also
#

conda create -y -n base_py3.6 python=3.6
# preven python 3.6 from being upgrade (this might just be me being paranoid
# though)
echo "python 3.6.*" >> $conda_prefix/conda-meta/pinned


#
# Install mpi4py
#

if [[ ! -d $conda_setup_path/tmp ]]; then
    mkdir $conda_setup_path/tmp
fi

pushd $conda_setup_path/tmp
# figure out the name of the downloaded (static) source
source_name=$(find ../../static -maxdepth 1 -name "mpi4py*" -type f)

# extract source
tar -xvf $source_name

# figure out the name of source dir
source_dir=$(find . -maxdepth 1 -name "mpi4py*" -type d)

# configure compiler
if [[ $USE_CC = true ]]; then
    mpicc_str="$(which cc) -shared"
else
    mpicc_str="$(which mpicc)"
fi

# no need to activate base -- `conda install` installs there by default
pushd $source_dir
# build mpi4py
echo "Compiling mpi4py with with --mpicc=$mpicc_str"
python setup.py build --mpicc="$mpicc_str"
python setup.py install
popd


# also build for base_py3.6
source activate base_py3.6
pushd $source_dir
# build mpi4py
echo "Compiling mpi4py with with --mpicc=$mpicc_str"
python setup.py build --mpicc="$mpicc_str"
python setup.py install
popd
conda deactivate

# clean up
rm -r $source_dir
popd


# Fix library version conflicts
source $conda_setup_path/helpers.sh

# activating base sets the `CONDA_PREFIX` environment variable
source activate base
_fix_sysversions
conda deactivate
source activate base_py3.6
_fix_sysversions
conda deactivate


echo "Conda is all set up in $conda_prefix"
echo " <- to use this version of conda, run 'source conda/env.local'"
