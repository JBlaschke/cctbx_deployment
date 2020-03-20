#!/usr/bin/env bash

source activate myenv
mpirun -n $1 python test_mpi4py.py
