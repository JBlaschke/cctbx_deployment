# deploy

Deployment scripts for CCTBX on various systems.

Make sure you get all the submodules:

```bash
git submodule update --init --recursive
```


## Installing from Scratch

Installing CCTBX takes 3 steps:

1. Install the local miniconda app
2. Install each pipeline's conda environment
3. Install CCTBX and psana2


### Installing the local miniconda app

This installs the latest miniconda to `conda/miniconda3/`, and builds `mpi4py`
using the local MPI installation. To install, run:

```bash
./conda/install_conda.sh
```

You can use this install by calling: `source conda/env.local`


### Installing each pipeline's conda environment

Run:

```bash
./conda/setup_env.sh
```

This will install all the conda environments needed by the different cctbx
pipelines deployed here. To use, call: `source conda/env.sh`


### Installing CCTBX and psana2


Currently only the xtc pipeline has been deplyed here. Install using:

```bash
./pipelines/xtc_process/setup_xtc.sh
```


## Running

Assuming you have the `LD91` data set, and you've built cctbx and it's
dependencies, then you can begin running some tests. Before running any tests,
I recommend checking out the `import_ext` branch:

```bash
cd pipelines/xtc_process/cctbx/modules/cctbx_project/
git checkout import_ext
cd ../../build
make
```

Note that the `pipelines/xtc_process/env.local` sets all approppriate paths,
this needs to be sourced before running CCTBX. You can now happily process your
data :). For an example, this will analyze the first 1000 images in the `LD91`
data set (that is assumed to live in your SCRATCH):

```bash
cd pipelines/xtc_process/run/
source ../env.local
./index_lite_ex.sh cxid9114 95 12 none 1000 $SCRATCH/LD91
```

The `index_lite_ex.sh` logs to `stdout`, so the version above is best for
debugging on an interactive node. For a massively parallel run, this:

```bash
cd pipelines/xtc_process/run/
source ../env.local
./index_lite.sh cxid9114 95 12 none 0 $SCRATCH/LD91
```
analyzes the _whole_ `LD91` data set, and logs to `output'.
