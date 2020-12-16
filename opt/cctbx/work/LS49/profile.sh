suffix=$(bash -c 'echo $LS_JOBPID')

nsys profile -o report-${suffix} libtbx.python $(libtbx.find_in_repositories LS49)/adse13_196/step5_batch.py
