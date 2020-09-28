#!/bin/bash -l

#SBATCH -q special    # regular or special queue
#SBATCH -N 1          # Number of nodes
#SBATCH -t 01:10:00   # wall clock time limit
#SBATCH -J test_gpu_job
#SBATCH -L SCRATCH    # job requires SCRATCH files
#SBATCH -C gpu
#SBATCH -A m1759      # allocation
#SBATCH -G 8          # devices per node
#SBATCH -exclusive    # total threads requested per node
#SBATCH -o slurm%j.out
#SBATCH -e slurm%j.err
#SBATCH --mail-user=jpblaschke@lbl.gov
#SBATCH --mail-type=ALL
#SBATCH --exclusive

# -n, tasks to run; -N number of nodes; -c cpus per task;
# n = N x tasks_per_node (should be 40 tasks per node for Cori-gpu)

export USE_EXASCALE_API=True # "True" or "False" use granular host/device memory transfer
export LOG_BY_RANK=1 # Use Aaron's profiler/rank logger
# export N_SIM=240 # total number of images to simulate
export ADD_SPOTS_ALGORITHM=cuda # cuda or JH or NKS
# export DEVICES_PER_NODE=1

mkdir -p LS49/$SLURM_JOB_ID;
cd LS49/$SLURM_JOB_ID

date;ls

# nsys profile srun -n 40 python $(libtbx.find_in_repositories LS49)/adse13_196/step5_batch.py
# srun -n 40 nsys profile python $(libtbx.find_in_repositories LS49)/adse13_196/step5_batch.py
# srun -n 10 python $(libtbx.find_in_repositories LS49)/adse13_196/step5_batch.py


# export N_SIM=2 # total number of images to simulate
# export DEVICES_PER_NODE=1
# nsys profile srun -n 1 python $(libtbx.find_in_repositories LS49)/adse13_196/step5_batch.py

# export N_SIM=10 # total number of images to simulate
# export DEVICES_PER_NODE=1
# nsys profile srun -n 5 python $(libtbx.find_in_repositories LS49)/adse13_196/step5_batch.py

# export N_SIM=20 # total number of images to simulate
# export DEVICES_PER_NODE=2
# nsys profile srun -n 10 python $(libtbx.find_in_repositories LS49)/adse13_196/step5_batch.py

export N_SIM=40 # total number of images to simulate
export DEVICES_PER_NODE=4
nsys profile srun -n 20 python $(libtbx.find_in_repositories LS49)/adse13_196/step5_batch.py



# Reproduce behavior prior to adse13-161 Python reorg that pre-computes energy channels.
#srun -n 40 -c 2 libtbx.python $(libtbx.find_in_repositories LS49)/adse13_161/step5_batch.py

date;ls
sleep 5
