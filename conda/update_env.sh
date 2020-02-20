#!/usr/bin/env bash


# stop running if there's an error
set -e


# load dependencies
source $(dirname ${BASH_SOURCE[0]})/../gears.sh
source $(dirname ${BASH_SOURCE[0]})/../load_modules.sh


# load site-specific variables: XTC_**
if [[ $NERSC_HOST = "cori" ]]; then
    source $(dirname ${BASH_SOURCE[0]})/../cori_deps.sh
fi


# access "our conda"
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


# update user
echo "UPDATING CONDA ENV $XTC_CONDA_ENV"
source activate $XTC_CONDA_ENV
# Don't use `-y` => the user should review the updates
conda update --all $(_channel_list ${XTC_CONDA_CH[@]})
