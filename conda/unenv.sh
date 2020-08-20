#!/usr/bin/env bash

#
# Remove stuff from PATH
# cf: https://unix.stackexchange.com/a/291611
#

__path_remove() {
  # Delete path by parts so we can never accidentally remove sub paths
  eval "$1=\${$1//\":$2:\"/\":\"}" # ${$1//":$2:"/":"} -> delete any instances in the middle
  eval "$1=\${$1/#\"$2:\"/}"       # ${$1/#"$2:"/}     -> delete any instance at the beginning
  eval "$1=\${$1/%\":$2\"/}"       # ${$1/%":$2"/}     -> delete any instance in the at the end
}

__path_remove PATH $PATHSTR
__path_remove PATH $CONDABIN
