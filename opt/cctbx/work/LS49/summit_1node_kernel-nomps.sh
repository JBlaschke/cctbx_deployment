#!/bin/bash
#BSUB -P CHM137
#BSUB -W 01:00
#BSUB -nnodes 1
#BSUB -alloc_flags "gpudefault"
#BSUB -o job%J.out
#BSUB -e job%J.err
cd ${PWD}/LS49
mkdir ${LSB_JOBID}
cd ${LSB_JOBID}

export USE_EXASCALE_API=True # "True" or "False" use granular host/device memory transfer
export LOG_BY_RANK=1 # Use Aaron's rank logger
export RANK_PROFILE=0 # 0 or 1 Use cProfiler, default 1
# export N_SIM=240 # total number of images to simulate
export ADD_SPOTS_ALGORITHM=cuda # cuda or JH or NKS
export ADD_BACKGROUND_ALGORITHM=cuda # cuda or jh or sort_stable
export DEVICES_PER_NODE=1


echo "jobstart $(date)";pwd;ls

jsrun -n 6 -a 7 -c 7 -r 6 -g 1 libtbx.python $(libtbx.find_in_repositories LS49)/adse13_196/test_mpi.py

# jsrun -n 6 -a 7 -c 7 -r 6 -g 1 libtbx.python $(libtbx.find_in_repositories LS49)/adse13_196/step5_batch.py

export N_SIM=14
jsrun -n 1 -a 7 -c 7 -r 1 -g 1  nv-nsight-cu-cli --set full --target-processes all -o report_%q{OMPI_COMM_WORLD_RANK} libtbx.python $(libtbx.find_in_repositories LS49)/adse13_196/step5_batch.py

# jsrun -n 6 -a 7 -c 7 -r 6 -g 1 libtbx.python $(libtbx.find_in_repositories LS49)/adse13_196/step5_batch.py


jsrun -n 6 -a 7 -c 7 -r 6 -g 1 libtbx.python $(libtbx.find_in_repositories LS49)/adse13_196/test_mpi.py

echo "jobend $(date)";pwd

# -alloc_flags "gpumps" The GPU devices can be accessed by multiple MPI ranks
# DEVICES_PER_NODE=1    In the Summit architecture, the GPU DeviceID is always 0
# -n 6                  --nrs number of resource sets, 6 per node
# -a 7                  --tasks_per_rs number of MPI ranks per resource set
# -c 7                  --cpu_per_rs CPU cores per resource set (42 per node)
# -r 6                  --rs_per_host resource sets per node
# -d packed             --launch_distribution, packed is the default
# Explained at https://docs.olcf.ornl.gov/systems/summit_user_guide.html#batch-scripts
