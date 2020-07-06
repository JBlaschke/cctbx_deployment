# Additional instructions for LS49

These are the aditional instructions for using LS49. You will still need to run
`./install_all.sh` [documented here](README.md) before following these
instructions.

1. Add the LS49 module
```
cd opt/cctbx/modules
git clone https://github.com/nksauter/LS49.git
```
2. Re-build CCTBX (from the `/opt/cctbx/build` directory)
```
cd opt/cctbx/build
python ../modules/cctbx_project/libtbx/configure.py --enable_openmp_if_possible=True --enable_cuda LS49 prime iota --use_conda
source setpaths.sh
make
```
