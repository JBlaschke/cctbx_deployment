#!/usr/bin/env bash

# Run Benchmark
pushd /img/data
python /img/opt/divelite/xtc1to2/extend_xtc.py /img/data/data-r0001-s00.xtc2 $2 33
/img/opt/divelite/xtc1to2/post_extend.sh
popd

pushd /img/run
mpirun -n $1 ./index_lite.sh cxid9114 1 12 none 0 /img/data/tmp
popd

# Report Performancestats
python /img/opt/cctbx_profiling/run_stats.py /img/run/output/debug
