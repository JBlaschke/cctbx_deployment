#!/usr/bin/env bash



# load conda stuff
source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/env/env.sh



# parse inputs
nproc=4
omp_str=--config-flags="--enable_openmp_if_possible=True"
bin_str=--config-flags="--no_bin_python"
while test $# -gt 0; do
    case "$1" in
        -h|-help)
            echo "Valid flags are:"
            echo "  1. -nproc \$<Number of CPUS>"
            echo "  2. -no-omp"
            echo "  3. -bin-python"
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
        *)
            echo "Error: could not parse: $1"
            exit 0
            ;;
    esac
done



# get the directory of this pipeline
my_dir=$(dirname ${BASH_SOURCE[0]})
pipeline_dir=$(readlink -f $my_dir)



#
# Build CCTBX
#

export CCTBX_PREFIX=$pipeline_dir/cctbx

# extract static resources
pushd $CCTBX_PREFIX/modules
for name in *.gz
do
    tar -xvf $name
done
for name in *.zip
do
    # delete previously-extracted folders
    filename="${name%.*}" 
    if [[ -e $filename ]]; then
        rm -r $filename
    fi
    unzip $name
done

scons_name=$(find . -maxdepth 1 -name "scons*" -type d)
if [[ -d scons ]]; then
    rm -r scons
fi
mv $scons_name scons
popd


# build cctbx
pushd $CCTBX_PREFIX
echo "Running boostrap build with $nproc processors"
echo "  -> python bootstrap.py build --builder=dials --use-conda $CONDA_PREFIX --nproc=$nproc $omp_str $bin_str"
python bootstrap.py build --builder=dials --use-conda $CONDA_PREFIX --nproc=$nproc $omp_str $bin_str
popd
