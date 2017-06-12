#!/bin/sh

CWD=`pwd`

echo "====================== Make lables ==========================="
for SID in `seq 34`; do
    echo ""
    echo "-------- Speaker $SID --------"

    cd $CWD
    fname1="labels/id$SID.mlf"
    fname2="labelsn/id$SID.mlf"
    awk '{if(substr($1,1,1)==".") {print "sil"; print $0;} else print $0 }' $fname1 |awk '{if(substr($1,1,1)=="\"") {print $0; print "sil";} else print $0 }' >$fname2 

done
    
echo "----------------------------------------------------------"


