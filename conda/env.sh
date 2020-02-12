#!/usr/bin/env bash


source $(dirname ${BASH_SOURCE[0]})/../gears.sh
source $(dirname ${BASH_SOURCE[0]})/../load_modules.sh


# load site-specific variables: XTC_**
if [[ $NERSC_HOST = "cori" ]]; then
    source $(dirname ${BASH_SOURCE[0]})/../cori_deps.sh
fi


env_grep=$(conda env list | grep $XTC_CONDA_ENV)
if [[ -z $env_grep ]]; then
    echo "$XTC_CONDA_ENV does not exist... exiting"
    exit
fi

if [[ $NERSC_HOST = "cori" ]]; then
    source activate $XTC_CONDA_ENV
else
    conda activate $XTC_CONDA_ENV
fi
