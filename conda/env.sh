#!/usr/bin/env bash


# don's stop if errors => this is supposed to be sourced by the main environment
# set -e


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
if [[ ! $(type conda 2> /dev/null) ]]; then
    echo "NOT SO FAST! 'conda' has not been installed (yet)."
    echo "Make the conda tool available to the path, or run:"
    echo "    ./conda/install_conda.sh"
    return
fi


# check if the local environment exists
env_grep=$(conda env list | grep $XTC_CONDA_ENV || true)
if [[ -z $env_grep ]]; then
    echo "$XTC_CONDA_ENV does not exist... exiting"
    echo "To create a conda env, run:"
    echo "    ./conda/setup_env.sh"
    return
fi


# make sure that a conda env isn't already running
# redirect stderr because we might get the warning that conda hasn't modified
# the .bashrc (which we don't want to do anyway)
conda deactivate 2> /dev/null || true
# activate conda
source activate $XTC_CONDA_ENV


# Python version
export PYVER=$XTC_PYVER
