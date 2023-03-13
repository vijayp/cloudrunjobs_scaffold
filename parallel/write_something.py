#!/usr/bin/env python3
import os
import sys

SHARD_NUMBER = int(os.environ.get('CLOUD_RUN_TASK_INDEX'))
SHARD_COUNT = int(os.environ.get('CLOUD_RUN_TASK_COUNT'))
STORAGE_PREFIX = os.environ.get('STORAGE_PREFIX')

if __name__ == '__main__':
    with open(os.path.join(sys.argv[1], 'outfile1.txt'), 'w') as fd:
        fd.write('This is something written from task %5.0d out of %5.0d\n' % 
                 (SHARD_NUMBER + 1, SHARD_COUNT))