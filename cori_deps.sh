#!/usr/bin/env bash


#
# DEPENDENCIES for NERSC's Cori system
#

export XTC_REQ_MODULES=(
    "PrgEnv-gnu/6.0.5"
    "gcc/7.3.0"
    "cmake/3.14.4"
    "cuda/10.1.168"
)

export XTC_CONDA_ENV="xtc_base"

export XTC_PYVER="3.6"

export XTC_CONDA_REQ=(
    "xtc_default.txt"
    "xtc_lcls-ii.txt"
)

export XTC_CONDA_CH=(
    "default"
    "lcls-ii"
)

export XTC_PIP="xtc_pip.txt"
