#!/usr/bin/env bash


# this () { echo $(readlink -f $(dirname ${BASH_SOURCE[0]})); }
shopt -s expand_aliases
alias this="readlink -f \$(dirname \${BASH_SOURCE[0]})"



# don's stop if errors => this is supposed to be sourced by the main environment
# set -e


# parse inputs
cctbx_setpaths="false"
while test $# -gt 0; do
    case "$1" in
        -h|-help)
            echo "Valid flags are:"
            echo "  1. -cctbx-setpaths [default:false]"
            exit 0
            ;;
        -cctbx-setpaths)
            shift
            cctbx_setpaths="true"
            ;;
        *)
            echo "Error: could not parse: $1"
            exit 0
            ;;
    esac
done

export CCTBX_SETPATHS=${cctbx_setpaths}


# load local install
if [[ -e $(this)/env/env.local ]]; then
    source $(this)/env/env.local
else
    echo "Error! opt/env/env.local not found! try re-running mk_env.sh"
fi
