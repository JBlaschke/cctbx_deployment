#!/usr/bin/env bash


# load site-specific variables: XTC_REQ_MODULES
if [[ $NERSC_HOST = "cori" ]]; then
    source $(dirname ${BASH_SOURCE[0]})/../../cori_deps.sh
fi


# load modules
source $(dirname ${BASH_SOURCE[0]})/../../load_modules.sh


# load conda stuff
source $(dirname ${BASH_SOURCE[0]})/../../conda/env.sh


# ensure that the lcls2 submodule is all there
git submodule update --init --recursive


# get the directory of this pipeline
my_dir=$(dirname ${BASH_SOURCE[0]})
pipeline_dir=$(readlink -f $my_dir)


# generate a local env
cat > env.local <<EOF
#
# Automaticall generated using setup_xtc
#


# load site-specific variables: XTC_REQ_MODULES
if [[ $NERSC_HOST = "cori" ]]; then
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
export PATH="$LCLS2_DIR/install/bin:\$PATH"
export PYTHONPATH="$LCLS2_DIR/install/lib/python\$PYVER/site-packages:\$PYTHONPATH"

pushd $LCLS2_DIR
./build_all.sh -d
popd


#
# Build CCTBX
#

export CCTBX_PREFIX=$pipeline_dir/cctbx

# build cctbx
pushd $CCTBX_PREFIX
python bootstrap.py update build --builder=dials --python3 --use-conda $CONDA_PREFIX --nproc=4
popd
