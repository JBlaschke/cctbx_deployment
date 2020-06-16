# Working within a Container: Docker/Shifter

[[_TOC_]]

To build the docker image -- called `cctbx:latest` -- run:
```bash
./build_docker.sh
```

Pre-built docker images can be downloaded form docker hub [here][1], using:

```bash
docker pull jblaschke/cctbx:latest
```

**Note:** more instructions on using docker [here](docker/README.md).


## Running Docker Containers

Running is easy:

```bash
docker run cctbx:latest <args>
```

and `<args>` are runtime arguments.


## Running within Docker/Shifter Containers

To run the benchmark using Docker, run

```bash
docker run cctbx:latest mpirun -n <N MPI> /img/run/index_lite.sh <args>
```

where `<N MPI>` is the number of MPI ranks to be used. Note that `<N MPI>` can
either be 1, or it must be greater than 3 as psana2 reserves the first 2 ranks
for file IO. `<args>` are the arguments of `index_lite.sh`.



## Considerations for Shifter

For HPC container runners, like shifter, we should use the host's job runner
(instead of just `mpirun`) to deploy shifter -- i.e. it needs to be invoked
_outside_ of the container. In this case, the command above becomes:

```bash
srun -n <N MPI> shifter --image=docker:<account>/cctbx:latest /img/run/index_lite.sh <args>
```

where `<account>` is the docker-hub account hosting the shifter image. Note
that shifter treats images as read-only, hence the command needs to be invoked
from the working directory (just like the usual jobscrip).
