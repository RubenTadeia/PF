#!/bin/bash

for id in `seq 34` ; do
    echo speaker: $id
    scripts/do_make_mfcc.sh data/test/id$id features/mfcc/test/id$id
done

