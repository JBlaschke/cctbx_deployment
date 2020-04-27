#!/usr/bin/env bash

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
