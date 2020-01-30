#!/usr/bin/env bash


source load_modules.sh


# load site-specific variables: XTC_**
if [[ $NERSC_HOST = "cori" ]]; then
    source cori_deps.sh
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
else
    # WARNING: don't forget mpi4py.
    # to this end note: `env MPICC="$(which cc) -shared" pip install mpi4py`
    # cf. https://mpi4py.readthedocs.io/en/stable/install.html
    echo "Not implemented!"
    exit
fi

# install packages from default conda channel
for pkg in $XTC_CONDA_PKG[@]; do
    conda install -y $pkg
done

# install packages from different channels
N=${#XTC_FORGE_PKG[@]}
for (( i=0; i<N; i++)); do
    conda install -y ${XTC_FORGE_PKG[$i]} -c ${XTC_FORGE_CH[$i]}
done



echo ""

