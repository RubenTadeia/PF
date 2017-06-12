#!/bin/sh
##########################################################
# The 2nd CHiME Challenge - Speech Recognition Script    #
#                                                        #
# Authored by Ning Ma, University of Sheffield, and      #
# modified by Emmanuel Vincent, INRIA                    #
#                                                        #
# Any problem please report to emmanuel.vincent@inria.fr #
# Version 0.2, July 6, 2012                              #
##########################################################

# modified by group 8

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

HMMROOT="$REC_ROOT/models"
MIX="7mix"
wdlist="$REC_ROOT/etc/wdlist2"
dict="$REC_ROOT/etc/dict2"
config="$REC_ROOT/etc/config_train.$FEAT_TYPE"

echo "--------------------------------------"
echo "Generating forced alignments using Speaker Dependent models"
for SID in `seq 2`; do
    echo "  speaker id$SID"
    #SI
    hmms="$HMMROOT/train$MIX/SI/hmm$MIX.d/newMacros"
    if [ ! -r "$hmms" ]; then
        echo "Unable to access HMM file: $hmms"
        exit
    fi
    trainlist="$TMPDIR/trainlist.id$SID.$TMPID"
    awk '{printf("'$FEAT_ROOT'/id'$SID'/%s.'$FEAT_TYPE'\n", $1)}' $REC_ROOT/flists/train_id$SID.list > $trainlist
    labelmlf="$REC_ROOT/labels/plates/id${SID}Forced.mlf"

    for PLATE in `find $REC_ROOT/$FEAT_ROOT/id$SID -name \*.$FEAT_TYPE -print`; do
        LENGTH=`expr length $PLATE`
        INDEX=$(($LENGTH-10))
        PLATE=`expr substr $PLATE $INDEX 11`

        NUMBER=`expr substr $PLATE 1 6`
        alignedmlf="$ALIGN_ROOT/id${SID}_${NUMBER}.mlf"

        echo $PLATE
        $CMD_HVite -l '*' -o SW -C $config -a -H $hmms -i $alignedmlf -y lab -I $labelmlf $dict $wdlist $FEAT_ROOT/id$SID/$PLATE > /dev/null

    # HVite -l '*' -o SW -C etc/config_train.mfcc -a -H models/train3mix/SI/hmm3mix.d/newMacros -i matricula.mlf -y lab 
    # -I id1Forced17ad92.mlf etc/dict2 etc/wdlist2 features/mfcc/test2/id1/17ad92.mfcc

    done

    rm -f $trainlist
done

# Cleaning up
rm -f $trainlist

echo "----------------------------------------------------------"
echo "Alignments are saved in $ALIGN_ROOT"

