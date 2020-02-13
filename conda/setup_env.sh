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


env_grep=$(conda env list | grep $XTC_CONDA_ENV)
if [[ -n $env_grep ]]; then
    echo "$XTC_CONDA_ENV already exists... exiting"
    exit
fi


# update user
echo "BUILDING NEW CONDA ENV $XTC_CONDA_ENV"


# create conda environment
if [[ $NERSC_HOST = "cori" ]]; then
    # use `--clone base` on cori
    conda create -y -n $XTC_CONDA_ENV --clone base
    # activate the new environment (cori's way of activating conda environments)
    source activate $XTC_CONDA_ENV
    # Cori's conda base environment can contain gcc (r dependency?) =>
    # uninstall them from our local env, to avoid conflicts with the system
    # compilers
    conda uninstall -y ${XTC_CONDA_BLACKLIST[@]}
else
    # WARNING: don't forget mpi4py.
    # to this end note: `env MPICC="$(which cc) -shared" pip install mpi4py`
    # cf. https://mpi4py.readthedocs.io/en/stable/install.html
    echo "Not implemented!"
    exit
    # TODO: don't forget to activate the conda environment:
    # conda activate $XTC_CONDA_ENV
fi


# install conda packages
echo "ADDING PACKAGES TO CONDA ENV $XTC_CONDA_ENV"
conda install -y ${XTC_CONDA_PKG[@]} $(_channel_list ${XTC_CONDA_CH[@]})


# install pip packages
echo "ADDING PIP PACKAGES TO CONDA ENV $XTC_CONDA_ENV"
pip install ${XTC_PIP_PKG[@]}


echo ""
