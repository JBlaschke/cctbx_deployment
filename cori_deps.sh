#!/usr/bin/env bash


#
# DEPENDENCIES for NERSC's Cori system
#

# export XTC_REQ_MODULES=(
#     "PrgEnv-gnu/6.0.5"
#     "python/3.6-anaconda-5.2"
#     "cuda/10.1.168"
# )
export XTC_REQ_MODULES=(
    "PrgEnv-gnu/6.0.5"
    "gcc/7.3.0"
    "cmake/3.14.4"
    "cuda/10.1.168"
)

export XTC_CONDA_ENV="xtc_base"

export XTC_PYVER="3.6"

# export XTC_CONDA_PKG=(
#     "_libgcc_mutex"
#     "cmake"
#     "numpy"
#     "cython"
#     "matplotlib"
#     "pytest"
#     "mongodb"
#     "pymongo"
#     "curl"
#     "rapidjson"
#     "ipython"
#     "requests"
#     "mypy"
#     "h5py"
#     "biopython"
#     "future"
#     "jinja2"
#     "mock"
#     "msgpack-python"
#     "pillow"
#     "psutil"
#     "pytest-mock"
#     "pytest-xdist"
#     "pyyaml"
#     "reportlab"
#     "scikit-learn"
#     "six"
#     "mypy_extensions"
#     "rhash"
#     "tabulate"
#     "tqdm"
#     "amityping"
#     "bitstruct"
# )

# export XTC_CONDA_CH=(
#     "default"
#     "lcls-ii"
#     "conda-forge"
# )

export XTC_CONDA_REQ=(
    "xtc_default.txt"
    "xtc_lcls-ii.txt"
)

export XTC_CONDA_CH=(
    "default"
    "lcls-ii"
)

# export XTC_PIP_PKG=(
#     "orderedset"
#     "dials-data"
#     "procrunner"
# )

export XTC_PIP="xtc_pip.txt"
