#!/usr/bin/env bash


# this () { echo $(readlink -f $(dirname ${BASH_SOURCE[0]})); }
shopt -s expand_aliases
alias this="readlink -f \$(dirname \${BASH_SOURCE[0]})"


#-------------------------------------------------------------------------------
# PARSE INPUTS

_overwrite_host=false
_host=""
while test $# -gt 0; do
    case "$1" in
        -h|-help)
            echo "Valid flags are:"
            echo "  1. -overwrite-host"
            exit 0
            ;;
        -overwrite-host)
            shift
            _overwrite_host=true
            _host=$1
            shift
            ;;
        *)
            echo "Error: could not parse: $1"
            exit 0
            ;;
    esac
done

if [[ $_overwrite_host == "true" ]]; then
    export CCTBX_HOST=$_host
else
    if [[ $NERSC_HOST == "cori" ]]; then
        export CCTBX_HOST="cori"
    else
        _hostname=$(hostname -f)
        if [[ ${_hostname#login*.} == "summit.olcf.ornl.gov" ]]; then
            # if running on login node
            export CCTBX_HOST="summit"
        elif [[ ${_hostname#batch*.} == "summit.olcf.ornl.gov" ]]; then
            # if running on interactive node
            export CCTBX_HOST="summit"
        fi
    fi
fi

#-------------------------------------------------------------------------------


# update user
user_msg="CHANGING MODULES"
user_msg_posted=0


# load helper functions _module_**
source $(this)/gears.sh


# load site-specific variables: XTC_REQ_MODULES
if [[ $CCTBX_HOST = "cori" ]]; then
    source $(this)/sites/cori.sh
fi

if [[ $CCTBX_HOST == "cgpu" ]]; then
    source $(this)/sites/cgpu.sh
fi

if [[ $CCTBX_HOST == "summit" ]]; then
    source $(this)/sites/summit.sh
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
