#!/bin/sh

CWD=`pwd`

echo "====================== Make lists ==========================="
for SID in `seq 34`; do
    echo ""
    echo "-------- Speaker $SID --------"

    cd $CWD
    CD1="data/train/id$SID"

    cd $CD1
    TMPID="train_id$SID.list"
    ls *.wav |sed 's/\.wav//' > $CWD/flists/$TMPID
done
    
echo "----------------------------------------------------------"

