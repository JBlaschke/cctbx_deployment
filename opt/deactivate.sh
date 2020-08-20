#!/usr/bin/env bash


# this () { echo $(readlink -f $(dirname ${BASH_SOURCE[0]})); }
shopt -s expand_aliases
alias this="readlink -f \$(dirname \${BASH_SOURCE[0]})"

conda deactivate

if [[ -e $(this)/../conda/unenv.sh ]]; then
    source $(this)/../conda/unenv.sh
fi


__path_remove() {
  # Delete path by parts so we can never accidentally remove sub paths
  eval "$1=\${$1//\":$2:\"/\":\"}" # ${$1//":$2:"/":"} -> delete any instances in the middle
  eval "$1=\${$1/#\"$2:\"/}"       # ${$1/#"$2:"/}     -> delete any instance at the beginning
  eval "$1=\${$1/%\":$2\"/}"       # ${$1/%":$2"/}     -> delete any instance in the at the end
}


__path_remove PATH __LCLS2_PATHSTR
__path_remove PYTHONPATH __LCLS2_PYTHONPATHSTR


if [[ $CCTBX_SETPATHS == "true" ]]; then
    __path_remove PATH __CCTBX_PATHSTR
    __path_remove PYTHONPATH __CCTBX_PYTHONPATHSTR
    __path_remove LD_LIBRARY_PATH __CCTBX_LDLIBRARYPATHSTR
else
    source $CCTBX_PREFIX/build/unsetpaths.sh
fi
