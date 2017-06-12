#!/bin/bash

for id in `seq 34` ; do
    echo speaker: $id
    scripts/do_make_mfcc.sh data/dev/id$id features/mfcc/dev/id$id
done

