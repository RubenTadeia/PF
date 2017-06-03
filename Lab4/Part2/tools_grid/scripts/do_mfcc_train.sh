#!/bin/bash

for id in `seq 34` ; do
    echo speaker: $id
    scripts/do_make_mfcc.sh data/train/id$id features/mfcc/train/id$id
done

