#!/usr/bin/env bash


# stop when there's an error
set -e


# this () { echo $(readlink -f $(dirname ${BASH_SOURCE[0]})); }
shopt -s expand_aliases
alias this="readlink -f \$(dirname \${BASH_SOURCE[0]})"



# load conda stuff
source $(this)/env/env.sh


# generate a local env
LC_ALL=en_US.UTF-8
LIBTBX_BUILD=$(readlink -f $(this)/cctbx/build)
LIBTBX_MODULE=$(readlink -f $(this)/cctbx/modules)
CCTBX_MODULE=$(readlink -f $(this)/cctbx/modules/cctbx_project)

LCLS2_DIR="$(this)/lcls2"
CCTBX_PREFIX="$(this)/cctbx"


cat > $(this)/env/env.local <<EOF
#
# update PATH (this is local to the current machine)
# Automaticall generated using setup_xtc.sh
#

# load site-specific variables: XTC_**
source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/env/vars.sh


# load environment
source $(this)/env/env.sh


# variables needed to run psana
export LCLS2_DIR="${LCLS2_DIR}"
export __LCLS2_PATHSTR="${LCLS2_DIR}/install/bin"
export __LCLS2_PYTHONPATHSTR="${LCLS2_DIR}/install/lib/python${PYVER}/site-packages"
if [[ -d \$__LCLS2_PATHSTR ]]; then
    if [[ ":\${PATH}:" != *\${__LCLS2_PATHSTR}* ]]; then
        export PATH="\${PATH}:\${__LCLS2_PATHSTR}"
    fi
    if [[ ":\${PYTHONPATH}:" != *\${__LCLS2_PYTHONPATHSTR}* ]]; then
        export PYTHONPATH="\${PYTHONPATH}:\${__LCLS2_PYTHONPATHSTR}"
    fi
fi


# variables needed to run CCTBX
export CCTBX_PREFIX="${CCTBX_PREFIX}"
if [[ \${CCTBX_SETPATHS} == "true" ]]; then
    if [[ -e \${CCTBX_PREFIX}/build/setpaths.sh ]]; then
        source \${CCTBX_PREFIX}/build/setpaths.sh
    fi
else
    export LC_ALL=en_US.UTF-8
    export LIBTBX_BUILD="${LBTBX_BUILD}"
    export LIBTBX_MODULE="${LIBTBX_MODULE}"
    export CCTBX_MODULE="${CCTBX_MODULE}"


    export LIBTBX_PYEXE_BASENAME="python${PYVER}"
    export SSL_CERT_FILE="${CONDA_PREFIX}/lib/python3.6/site-packages/certifi/cacert.pem"
    export OPENBLAS_NUM_THREADS="1"

    export __CCTBX_PYTHONPATHSTR="${CCTBX_MODULE}:${LIBTBX_MODULES}:${LIBTBX_BUILD}/lib:${CONDA_PREFIX}/lib/python3.6/site-packages"
    if [[ ":\${PYTHONPATH}:" != *\${__CCTBX_PYTHONPATHSTR}* ]]; then
        export PYTHONPATH="\${PYTHONPATH}:\${__CCTBX_PYTHONPATHSTR}"
    fi

    export __CCTBX_PATHSTR="${LIBTBX_BUILD}/bin"
    if [[ ":\${PATH}:" != *\${__CCTBX_PATHSTR}* ]]; then
        export PATH="\${PATH}:\${__CCTBX_PATHSTR}"
    fi

    export __CCTBX_LDLIBRARYPATHSTR="${LIBTBX_BUILD}/lib:${CONDA_PREFIX}/lib"
    if [[ ":\${LD_LIBRARY_PATH}:" != *\${__CCTBX_LDLIBRARYPATHSTR}* ]]; then
        export LD_LIBRARY_PATH="\${LD_LIBRARY_PATH}:\${__CCTBX_LDLIBRARYPATHSTR}"
    fi
fi
EOF
