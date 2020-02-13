#!/usr/bin/env bash


#
# DEPENDENCIES for NERSC's Cori system
#

export XTC_REQ_MODULES=(
    "PrgEnv-gnu/6.0.5"
    "python/3.6-anaconda-5.2"
    "cuda/10.1.168"
)

export XTC_CONDA_ENV="xtc_base"

export XTC_CONDA_PKG=(
    "_libgcc_mutex"
    "cmake"
    "mongodb"
    "mypy_extensions"
    "pymongo"
    "rhash"
    "tabulate"
    "tqdm"
    "future"
    "rapidjson"
    "amityping"
    "bitstruct"
)

export XTC_CONDA_BLACKLIST=(
    "gcc_linux-64"
    "gcc_impl_linux-64"
)

export XTC_CONDA_CH=(
    "default"
    "lcls-ii"
    "conda-forge"
)

export XTC_PIP_PKG=(
    "orderedset"
    "dials-data"
    "procrunner"
)
