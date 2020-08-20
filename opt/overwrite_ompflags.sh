export CFLAGS="-g -O3 -fopenmp -fPIC -DUSE_OPENMP"
export LDFLAGS="-lgomp -L${OLCF_GCC_ROOT}/lib64"
