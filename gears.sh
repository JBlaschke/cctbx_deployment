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

_module_get_name_str () {
    # Check for "PrgEnv" modules => these are special
    if [[ ${@##PrgEnv} != $@ ]]; then
        echo "PrgEnv"
        return
    fi
    echo ${@%%/*};
}

_module_get_version_str () {
    # Check for "PrgEnv" modules => these are special
    if [[ ${@##PrgEnv} != $@ ]]; then
        echo ${@##*-};
        return
    fi
    echo ${@##*-};
}

_module_loaded () {
    mod_grep=$(module list 2>&1 | grep $@)

    if [[ -n $mod_grep ]]; then
        return 0
    else
        return 1
    fi
}

_channel_list () {
    ret=""

    for x in $@; do
        ret="$ret -c $x"
    done

    echo $ret
}
