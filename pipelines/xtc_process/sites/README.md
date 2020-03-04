# Notes for installing/running xtb_process pipeline

## Installing

1. **Important:** currently boost needs python 3.6
2. `myenv` environment cloned from base: `--clone base`
3. in `myenv` you need to make sure that `cmake` is installed
4. After building `lcls2`, run:
```bash
conda install -y amityping -c lcls-ii
conda install -y bitstruct -c conda-forge
conda install -y mongodb
conda install -y pymongo
```

## Working Branch

Working on the `psana2-det` branch in `cctbx_project`


## Running

1. `module load python/3.6-anaconda-5.2`
2. `source activate myenv`
3. `source env.sh`
4. then run:
```bash
./index_lite_ex.sh cxid9114 95 12 none 1000
```
