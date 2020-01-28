#!/usr/bin/env bash

#
# MODULE Helper functions
#


_module_get () {
    mod_grep=$(module list 2>&1 | grep $@)

    # ${mod_grep##*) } drop the ` N) ` part of the `module` output: drop
    # everything _before_ the `) ` character set
    echo ${mod_grep##*) }
}

_module_get_name_str () { echo ${@%%/*}; }

_module_get_version_str () { echo ${@##*/}; }

_module_loaded () {
    mod_grep=$(module list 2>&1 | grep $@)

    if [[ -n $mod_grep ]]; then
        return 0
    else
        return 1
    fi
}
