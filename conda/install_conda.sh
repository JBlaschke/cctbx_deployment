#!/usr/bin/env bash


# stop running if there's an error
set -e


#
# Run conda installer locally
#

# set up install path for the local conda path
conda_setup_dir=$(dirname ${BASH_SOURCE[0]})
conda_setup_path=$(readlink -f $conda_setup_dir)
conda_prefix=$conda_setup_path/miniconda3

# run conda installer
$conda_setup_path/Miniconda3-latest-Linux-x86_64.sh -b -p $conda_prefix


#
# update PATH (this is local to the current machine)
#

cat > $conda_setup_path/env.local <<EOF
# Add the local miniconda install to the PATH
export PATH=$conda_prefix/bin:\$PATH
EOF


#
# This conda install could be outdated => run update
#

source $conda_setup_path/env.local
conda update -y -n base -c defaults conda


#
# Make a temporary dir (for running build scripts)
#

if [[ ! -d $conda_setup_dir/tmp ]]; then
    mkdir $conda_setup_dir/tmp
fi


echo "Conda is all set up in $conda_prefix"
