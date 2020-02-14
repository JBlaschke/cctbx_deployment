#!/usr/bin/env bash


# stop if errors
set -e


source $(dirname ${BASH_SOURCE[0]})/../load_modules.sh


# load site-specific variables: XTC_**
if [[ $NERSC_HOST = "cori" ]]; then
    source $(dirname ${BASH_SOURCE[0]})/../cori_deps.sh
fi


# prepend local conda install
if [[ -e $(dirname ${BASH_SOURCE[0]})/env.local ]]; then
    source $(dirname ${BASH_SOURCE[0]})/env.local
fi


# check if conda tool exists in path
if [[ ! -x "$(command -v conda)" ]]; then
    echo "NOT SO FAST! 'conda' has not been installed (yet)."
    echo "Make the conda tool available to the path, or run:"
    echo "    ./conda/install_conda.sh"
    exit
fi


# check if the local environment exists
env_grep=$(conda env list | grep $XTC_CONDA_ENV || true)
if [[ -z $env_grep ]]; then
    echo "$XTC_CONDA_ENV does not exist... exiting"
    echo "To create a conda env, run:"
    echo "    ./conda/setup_env.sh"
    exit
fi


# activate conda
source activate $XTC_CONDA_ENV


# Python version
export PYVER=$XTC_PYVER
