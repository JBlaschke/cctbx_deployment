#!/usr/bin/env bash


# load helper functions _module_**
source gears.sh


# load site-specific variables: XTC_REQ_MODULES
if [[ $NERSC_HOST = "cori" ]]; then
    source cori_deps.sh
fi



# load site-sepcific modules
for mod in ${XTC_REQ_MODULES[@]}; do

    # check if not already loaded
    if ! _module_loaded $mod; then
        # module base name and version
        mod_bn=$(_module_get_name_str $mod)

        # check if another version hasn't already been loaded
        if _module_loaded $mod_bn; then
            mod_existing=$(_module_get $mod_bn)
            echo "Switching from $mod_existing to $mod"
            module switch $mod_existing $mod
        else
            echo "Loading $mod"
            module load $mod
        fi
    fi
done
