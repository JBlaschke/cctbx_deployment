#!/usr/bin/env bash

_fix_sysversions () {
    # Fix libreadline.so warnings on Cori
    if [[ $NERSC_HOST == "cori" ]]; then
        pushd $CONDA_PREFIX/lib
        ln -sf /lib64/libtinfo.so.6
        ln -sf /usr/lib64/libuuid.so
        popd
    fi
}
