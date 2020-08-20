#!/usr/bin/env bash


# this () { echo $(readlink -f $(dirname ${BASH_SOURCE[0]})); }
shopt -s expand_aliases
alias this="readlink -f \$(dirname \${BASH_SOURCE[0]})"



# load conda stuff
source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/env/env.sh



# parse inputs
nproc=4
omp_str=--config-flags="--enable_openmp_if_possible=True"
bin_str=--config-flags="--no_bin_python"
comp_str=
env_str=
while test $# -gt 0; do
    case "$1" in
        -h|-help)
            echo "Valid flags are:"
            echo "  1. -nproc \$<Number of CPUS>"
            echo "  2. -no-omp"
            echo "  3. -bin-python"
            echo "  4. -comp-conda"
            echo "  5. -env-flags"
            exit 0
            ;;
        -nproc)
            shift
            nproc=$1
            shift
            ;;
        -no-omp)
            shift
            omp_str=""
            ;;
        -bin-python)
            shift
            bin_str=""
            ;;
        -comp-conda)
            shift
            comp_str=--config-flags="--compiler=conda"
            ;;
        -env-flags)
            shift
            env_str=--config-flags="--use_environment_flags"
            ;;
        *)
            echo "Error: could not parse: $1"
            exit 0
            ;;
    esac
done



#
# Build CCTBX
#

export CCTBX_PREFIX=$(this)/cctbx

# extract static resources
pushd $CCTBX_PREFIX/modules
for name in *.gz
do
    if [[ -d ${name%.*} ]] || [[ -d ${name%-* } ]]; then
        echo "Skipping $name -- already extracted"
    else
        tar -xvf $name
    fi
done
for name in *.zip
do
    if [[ -d ${name%.*} ]] || [[ -d ${name%-* } ]]; then
        echo "Skipping $name -- already extracted"
    else
        # delete previously-extracted folders
        filename="${name%.*}" 
        if [[ -e $filename ]]; then
            rm -r $filename
        fi

        unzip $name
    fi
done

# scons needs to be moved to a directory called "scons"
if [[ ! -d scons ]]; then
    scons_name=$(find . -maxdepth 1 -name "scons*" -type d)
    mv $scons_name scons
fi

popd


# build cctbx
pushd $CCTBX_PREFIX
boostrap_str="--use-conda $CONDA_PREFIX --nproc=$nproc $omp_str $comp_str $env_str $bin_str"

echo "Running boostrap build with $nproc processors"
echo "  -> python bootstrap.py --builder=dials $boostrap_str"

python bootstrap.py build --builder=dials $boostrap_str
popd
