#!/usr/bin/env bash


# load conda stuff
source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/env/env.sh

# get the directory of this pipeline
my_dir=$(dirname ${BASH_SOURCE[0]})
pipeline_dir=$(readlink -f $my_dir)


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

