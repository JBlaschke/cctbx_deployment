#!/usr/bin/env bash


# update user
user_msg="CHANGING MODULES"
user_msg_posted=0


# load helper functions _module_**
source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/gears.sh


# load site-specific variables: XTC_REQ_MODULES
if [[ $NERSC_HOST = "cori" ]]; then
    source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/sites/cori.sh
fi


i=0

# load site-sepcific modules
for mod in ${XTC_REQ_MODULES[@]}; do

    let i+=1

    # check if not already loaded
    if ! _module_loaded $mod; then
        # module base name and version
        mod_bn=$(_module_get_name_str $mod)

        # update user ONLY if we're modifying the modules
        if [[ user_msg_posted -eq 0 ]]; then
            echo $user_msg
            user_msg_posted=1
        fi

        # check if another version hasn't already been loaded
        if _module_loaded $mod_bn; then
            mod_existing=$(_module_get $mod_bn)
            echo "$i. Switching from $mod_existing to $mod"
            module switch $mod_existing $mod
        else
            echo "$i. Loading $mod"
            module load $mod
        fi
    fi
done


# the user might prefer an empty line
if [[ user_msg_posted -gt 0 ]]; then
    echo ""
fi
