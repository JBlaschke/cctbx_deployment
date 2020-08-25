#!/usr/bin/env bash

export USE_EXASCALE_API=False # "True" or "False" use granular host/device memory transfer
export LOG_BY_RANK=1 # Use Aaron's profiler/rank logger
export N_SIM=240 # total number of images to simulate
export ADD_SPOTS_ALGORITHM=cuda # cuda or JH or NKS
export DEVICES_PER_NODE=8

export step5=$(libtbx.find_in_repositories LS49)/adse13_196/step5_batch.py

mkdir $SLURM_JOB_ID
cd $SLURM_JOB_ID
