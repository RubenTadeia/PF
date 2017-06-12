#!/bin/sh

CWD=`pwd`

echo "====================== Make lists ==========================="
for SID in `seq 34`; do
    echo ""
    echo "-------- Speaker $SID --------"

    cd $CWD
    CD1="data/dev/id$SID"

    cd $CD1
    TMPID="dev_id$SID.list"
    ls *.wav |sed 's/\.wav//' > $CWD/flists/$TMPID
done
    
echo "----------------------------------------------------------"

