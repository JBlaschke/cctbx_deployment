# deploy

Deployment scripts for CCTBX on various systems.

[[_TOC_]]


## Submodules/Git LFS

This repo makes extensive use of git submodules -- in order to ensure that all
submodules are up-to-date, run:

```bash
git submodule update --init --recursive
```

### LFS

Large resource files are tracked using git large file storage (LFS) -- in
order to update all LFS objects, run:

```bash
git lfs install
git lfs pull
```

**Note:** in order to use LFS, you might need to install it:
1. On macOS (using homebrew) run:
```bash
brew install git-lfs
```
2. On NERSC Cori run:
```bash
module load git-lfs
```


## Avoiding the Distpatchers

CCTBX can be installed into the `$CONDA_PREFIX` -- avoiding the need for the
dispatcher scripts. This is necessary if the computing environment reacts
badly to modifications of `$LD_LIBRARY_PATH`. In this case, you need to run:
```bash
./opt/install_to_conda.sh
```

**NOTE:** you need to run `source opt/cctbx/build/unsetpaths.sh` whenever you
source'ed `opt/env.local` IF you don't want the have the dispatchers in your
`$PATH` -- but this is not strictly necessary.


## Working within a Container: Docker/Shifter

This deployment script is a little different for containerized workflows.
Building (and running) docker images is described [here](README_DOCKER.md) in
more detail.


## Working outside of a Container

To build, run:

```bash
./install_all.sh
```

This does the following:
1. Ensure that all git submodules have been initialized
2. Load site-specific modules/settings
3. Install the local miniconda app
4. Install the pipeline's conda environment
5. Install CCTBX and psana2


### Running outside of Docker/Shifter Containers

For example, running the xtc processing pipeline involves 2 steps:

1. Activate local environment (from repository root):

```bash
source opt/env.local
```

* Denpending on your compute environment, you might also need to load the
  required modules (this does not happen automatically as it is not always
  necessary):

```bash
source opt/env/load_modules.sh
```

2. Run the xtc processing pipeline (from the `run` folder):

```bash
pushd
[srun|mpirun] ./index_lite.sh cxid9114 1 12 none 1000 ../data/tmp
popd
```

cf [README_DOCKER.md](README_DOCKER.md) for instructions on running inside a
docker/shifter container.


[1]: https://hub.docker.com/repository/docker/jblaschke/cctbx
