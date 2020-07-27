#!/usr/bin/env bash


# stop running if there's an error
set -e


# load site-specific variables: XTC_**
source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/vars.sh


# access "our conda"
if [[ -e $(readlink -f $(dirname ${BASH_SOURCE[0]}))/../../conda/env.local ]]; then
    source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/../../conda/env.local
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


# create new conda environment (things specific to the particular compute
# environment are kept in `base`)
conda create -y -n $XTC_CONDA_ENV --clone base_py$XTC_PYVER
# activate the new environment (this way we do not need to do `conda init
# <shell name>`, as this is not compatible with all compute environments ...
# cough... nersc ... cough...)
source activate $XTC_CONDA_ENV
# Make sure that python is not upgraded
echo "python $XTC_PYVER.*" >> $CONDA_PREFIX/conda-meta/pinned


# install conda and pip packages
pkg_data_dir=$(readlink -f $(dirname ${BASH_SOURCE[0]}))/pkg_data

echo "ADDING PACKAGES TO CONDA ENV $XTC_CONDA_ENV"
# conda install -y ${XTC_CONDA_PKG[@]} $(_channel_list ${XTC_CONDA_CH[@]})
for (( i=0; i<${#XTC_CONDA_REQ[@]}; ++i )); do
    conda install -y --file $pkg_data_dir/${XTC_CONDA_REQ[$i]} -c ${XTC_CONDA_CH[$i]}
done

echo "ADDING PIP PACKAGES TO CONDA ENV $XTC_CONDA_ENV"
# pip install ${XTC_PIP_PKG[@]}
pip install -r $pkg_data_dir/$XTC_PIP


echo ""


# Fix libreadline.so warnings on Cori
if [[ $NERSC_HOST == "cori" ]]; then
    pushd $CONDA_PREFIX/lib
    ln -sf /lib64/libtinfo.so.6
    popd
fi


conda deactivate
