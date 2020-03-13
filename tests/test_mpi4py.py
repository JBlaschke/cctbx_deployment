#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
from mpi4py import MPI
from libtbx import easy_run

mpi_rank = MPI.COMM_WORLD.Get_rank()
mpi_size = MPI.COMM_WORLD.Get_size()

print(f"rank = {mpi_rank}, size = {mpi_size}")
