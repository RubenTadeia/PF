#!/bin/sh
##########################################################
# The Pascal CHiME Challenge - Forced Aligning Script    #
#                                                        #
# Any problem please report to:                          #
# Ning Ma, University of Sheffield, UK                   #
# n.ma@dcs.shef.ac.uk, 17/09/2010                        #
# version 0.1                                            #
##########################################################

#========================================================
# $REC_ROOT is the directory of the baseline recogniser 
#========================================================
CWD=`pwd`
cd `dirname $0`/..
REC_ROOT=`pwd`
cd $CWD

#========================================================
# $ALIGN_ROOT is the directory of forced alignments
#========================================================
ALIGN_ROOT="$REC_ROOT/forced_alignments"
mkdir -p $ALIGN_ROOT
if [ ! -d "$ALIGN_ROOT" ]; then
   echo "Error: Unable to create $ALIGN_ROOT"
   exit 1
fi

#========================================================
# Check if HTK binaries are included in $PATH 
#========================================================
CMD_HVite=`which HVite`
if [ ! -f $CMD_HVite ]; then
    echo "Error: Unable to locate HTK tool - HVite"
    echo "Please add its path into the environment variable PATH"
    exit
fi

#========================================================
# Main Script 
#========================================================
if [ ! $# -eq 2 ]; then
    echo ""
    echo "Usage: $0 FEAT_TYPE FEAT_ROOT"
    echo "       FEAT_TYPE  - feature type, e.g. mfcc"
    echo "       FEAT_ROOT  - feature directory that contains sub-directories id1, id2..."
    echo ""
    echo "eg $0 mfcc features/mfcc/train"
    echo ""
    exit 1
fi
FEAT_TYPE=$1
FEAT_ROOT=$2
if [ ! -d "$FEAT_ROOT" ]; then
   echo "Error: Unable to access $FEAT_TYPE features in $FEAT_ROOT"
   exit 1
fi

TMPDIR="$REC_ROOT/scripts/tmp"
TMPID="$FEAT_TYPE.`hostname`.`date +%Y%m%d.%H%M`.$$"

HMMROOT="$REC_ROOT/models/$FEAT_TYPE"
MIX="7mix"
wdlist="$REC_ROOT/etc/wdlist"
dict="$REC_ROOT/etc/dict"
config="$REC_ROOT/etc/config_train.$FEAT_TYPE"

echo "--------------------------------------"
echo "Generating forced alignments using Speaker Dependent models"
for SID in `seq 34`; do
    echo "  speaker id$SID"
    hmms="$HMMROOT/id$SID/hmm$MIX.d/newMacros"
    if [ ! -r "$hmms" ]; then
        echo "Unable to access HMM file: $hmms"
        exit
    fi
    trainlist="$TMPDIR/trainlist.id$SID.$TMPID"
    awk '{printf("'$FEAT_ROOT'/id'$SID'/%s.'$FEAT_TYPE'\n", $1)}' $REC_ROOT/flists/train_id$SID.list > $trainlist
    labelmlf="$REC_ROOT/labels/id$SID.mlf"
    alignedmlf="$ALIGN_ROOT/id$SID.mlf"
    $CMD_HVite -l '*' -o SW -C $config -a -H $hmms -i $alignedmlf -m -t 250.0 -y lab -I $labelmlf -S $trainlist $dict $wdlist > /dev/null
    rm -f $trainlist
done

# Cleaning up
rm -f $trainlist

echo "----------------------------------------------------------"
echo "Alignments are saved in $ALIGN_ROOT"


