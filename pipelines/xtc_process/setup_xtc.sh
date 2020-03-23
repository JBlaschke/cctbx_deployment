#!/usr/bin/env bash

# stop when there's an error
set -e


# load site-specific variables: XTC_**
source $(dirname ${BASH_SOURCE[0]})/../../general_deps.sh
if [[ $NERSC_HOST = "cori" ]]; then
    source $(dirname ${BASH_SOURCE[0]})/../../cori_deps.sh
fi


# load modules
source $(dirname ${BASH_SOURCE[0]})/../../load_modules.sh


# load conda stuff
source $(dirname ${BASH_SOURCE[0]})/../../conda/env.sh


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
source $(dirname ${BASH_SOURCE[0]})/../../general_deps.sh
if [[ \$NERSC_HOST = "cori" ]]; then
    source $pipeline_dir/../../cori_deps.sh
fi


# load environment
source $pipeline_dir/../../load_modules.sh
source $pipeline_dir/../../conda/env.sh


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


#
# Build PSANA2
#

# Set up the PYTHON Path
export LCLS2_DIR="$pipeline_dir/lcls2"
export PATH="$LCLS2_DIR/install/bin:$PATH"
export PYTHONPATH="$LCLS2_DIR/install/lib/python$PYVER/site-packages:$PYTHONPATH"

# use pushd since lcls2/build_all.sh uses pwd to find install dir
pushd $LCLS2_DIR

# We don't need to invoke gcc explictly... this is kept for reference (last
# working version from Mona)
# # CC=/opt/gcc/7.3.0/bin/gcc CXX=/opt/gcc/7.3.0/bin/g++ ./build_all.sh -d
# ... or the more portable version:
# CXX=$(which g++) CC=$(which gcc) ./build_all.sh -d
if [[ $NERSC_HOST = "cori" ]]; then
    # Cori-only: just in case static linking is used somewhere, overwrite:
    export CRAYPE_LINK_TYPE=dynamic
    # Specify compilers:
    export FC=$(which ftn)
    export LD=$(which ld)
    export CXX=$(which CC)
    export CC=$(which cc)

    # Build:
    ./build_all.sh -d
else
    # Specify compilers:
    export FC=$(which mpifort)
    export LD=$(which ld)
    export CXX=$(which mpicxx)
    export CC=$(which mpicc)

    # Build:
    ./build_all.sh -d
fi
popd


#
# Build CCTBX
#

export CCTBX_PREFIX=$pipeline_dir/cctbx

# build cctbx
pushd $CCTBX_PREFIX
# TODO: use Billy's new compiler wrappers, etc
python bootstrap.py hot update build --builder=dials --use-conda $CONDA_PREFIX --nproc=4
popd
