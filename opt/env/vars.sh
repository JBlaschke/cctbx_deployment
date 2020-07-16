#!/usr/bin/env bash


export XTC_CONDA_ENV="xtc_base"

export XTC_PYVER="3.6"


_hostname=$(hostname -f)
if [[ ${_hostname#login*.} == "summit.olcf.ornl.gov" ]]; then
    export XTC_CONDA_REQ=(
        "xtc_default_notag.txt"
        "xtc_lcls-ii_notag.txt"
    )

    export XTC_CONDA_CH=(
        "default"
        "lcls-ii"
    )
else
    export XTC_CONDA_REQ=(
        "xtc_default.txt"
        "xtc_lcls-ii.txt"
    )

    export XTC_CONDA_CH=(
        "default"
        "lcls-ii"
    )
fi

export XTC_PIP="xtc_pip.txt"
