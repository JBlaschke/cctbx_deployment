# Instructions on running here

## Proxy

Start proxy on login3 (if not on login 3, `ssh` there).

## Compute Node

```
bsub -W 1:00 -nnodes 1 -P chm137 -Is /bin/bash

```

## Run

```
source ../env.sh
./index_lite_ex.sh cxid9114 95 12 none 1000
```
