#!/bin/sh

./write_something.py /out/

# upload the files
# create bucket
gsutil ls -b gs://$STORAGE_PREFIX || gsutil mb gs://$STORAGE_PREFIX

gsutil -m cp -r /out/ gs://"$STORAGE_PREFIX"/"$CLOUD_RUN_TASK_INDEX"_of_"$CLOUD_RUN_TASK_COUNT"

