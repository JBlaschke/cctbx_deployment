#!/usr/bin/env bash

#SBATCH --image=docker:jblaschke/mpi4py:latest 
#SBATCH --nodes=1
#SBATCH --tasks-per-node=68
#SBATCH --constraint=knl
#SBATCH --qos=premium
#SBATCH --job-name=test_mpi4py_n1
#SBATCH --account=nstaff
#SBATCH --mail-user=jpblaschke@lbl.gov
#SBATCH --mail-type=ALL
#SBATCH --time=00:10:00


#OpenMP settings:
export OMP_NUM_THREADS=1
export OMP_PLACES=threads
export OMP_PROC_BIND=spread


#run the application:
START_SEC=$(date +"%s")  # cheap timer => but I also want to know init time
srun --cpu_bind=cores shifter /srv/mpi4py-entrypoint.sh python /srv/test_mpi4py.py
STOP_SEC=$(date +"%s")

ELAPSED=$((STOP_SEC-START_SEC))
echo "Total time elapsed ${ELAPSED} ${START_SEC} ${STOP_SEC} [s] (incl. init)"
