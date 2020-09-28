#!/usr/bin/env bash


export XTC_CONDA_ENV="xtc_base"

export XTC_PYVER="3.6"


_hostname=$(hostname -f)
if [[ ${_hostname#login*.} == "summit.olcf.ornl.gov" ]]; then
    # if running on login node
    export XTC_CONDA_REQ=(
        "xtc_default_power9.txt"
        "xtc_lcls-ii_power9.txt"
    )
elif [[ ${_hostname#batch*.} == "summit.olcf.ornl.gov" ]]; then
    # if running on interactive node
     export XTC_CONDA_REQ=(
        "xtc_default_power9.txt"
        "xtc_lcls-ii_power9.txt"
    )
else
    export XTC_CONDA_REQ=(
        "xtc_default_x86_64.txt"
        "xtc_lcls-ii_x86_64.txt"
    )
fi


export XTC_CONDA_CH=(
    "default"
    "lcls-ii"
)

export XTC_PIP="xtc_pip.txt"
