#!/usr/bin/env bash

source /opt/conda/env.local

mpirun -n $1 python test_mpi4py.py
