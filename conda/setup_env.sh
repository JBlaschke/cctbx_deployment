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


# check if already installed
# this will only match packages in the current env root
env_grep=$(conda env list | tr '/' 'x' | grep -w $XTC_CONDA_ENV  || true)
# don't match paths        ^^^^^^^^^^^^       ^^
if [[ -n $env_grep ]]; then
    echo "$XTC_CONDA_ENV already exists... exiting"
    exit
fi


# update user
echo "BUILDING NEW CONDA ENV $XTC_CONDA_ENV"


# create conda environment
if [[ $NERSC_HOST = "cori" ]]; then
    # create new conda environment (things specific to the particular compute
    # environment are kept in `base`)
    conda create -y -n $XTC_CONDA_ENV --clone base_py$XTC_PYVER
    # activate the new environment (cori's way of activating conda environments)
    source activate $XTC_CONDA_ENV
else
    # WARNING: don't forget mpi4py.
    # to this end note: `env MPICC="$(which cc) -shared" pip install mpi4py`
    # cf. https://mpi4py.readthedocs.io/en/stable/install.html
    echo "Not implemented!"
    exit
    # TODO: don't forget to activate the conda environment:
    # conda activate $XTC_CONDA_ENV
fi


# install conda and pip packages
pkg_data_dir=$(dirname ${BASH_SOURCE[0]})/pkg_data

echo "ADDING PACKAGES TO CONDA ENV $XTC_CONDA_ENV"
# conda install -y ${XTC_CONDA_PKG[@]} $(_channel_list ${XTC_CONDA_CH[@]})
for (( i=0; i<${#XTC_CONDA_REQ[@]}; ++i )); do
    conda install -y --file $pkg_data_dir/${XTC_CONDA_REQ[$i]} -c ${XTC_CONDA_CH[$i]}
done

echo "ADDING PIP PACKAGES TO CONDA ENV $XTC_CONDA_ENV"
# pip install ${XTC_PIP_PKG[@]}
pip install -r $pkg_data_dir/$XTC_PIP



echo ""
