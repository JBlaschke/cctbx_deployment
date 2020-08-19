#!/usr/bin/env bash


# don's stop if errors => this is supposed to be sourced by the main environment
# set -e

# this () { echo $(readlink -f $(dirname ${BASH_SOURCE[0]})); }
shopt -s expand_aliases
alias this="readlink -f \$(dirname \${BASH_SOURCE[0]})"


# prepend local conda install
if [[ -e $(this)/env.local ]]; then
    source $(this)/env.local
fi


# check if conda tool exists in path
if [[ ! $(type conda 2> /dev/null) ]]; then
    echo "NOT SO FAST! 'conda' has not been installed (yet)."
    echo "Make the conda tool available to the path, or run:"
    echo "    ./install_conda.sh"
    return
fi
