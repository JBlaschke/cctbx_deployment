#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
from mpi4py import MPI


mpi_rank = MPI.COMM_WORLD.Get_rank()
mpi_size = MPI.COMM_WORLD.Get_size()

print(f"rank = {mpi_rank}, size = {mpi_size}")
