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
