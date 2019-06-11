#!/bin/bash

# clear pagecache
sync && echo 1 > /proc/sys/vm/drop_caches
