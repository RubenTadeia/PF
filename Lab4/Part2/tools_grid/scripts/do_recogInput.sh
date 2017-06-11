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
if [ ! $# -eq 6 ]; then
    echo ""
    echo "Usage: $0 FEAT_TYPE MODELNAME SETNAME FEAT_ROOT"
    echo "       FEAT_TYPE  - feature type, e.g. mfcc"
    echo "       MODELNAME  - Unique ID for the acoustic models"
    echo "       SETNAME    - devel, test ..."
    echo "       FEAT_ROOT  - feature directory that contains features"
    echo "       NUMBER_MIX  - number os mixtures, e.g. 3mix, 5mix, 7mix"
    echo "       MODEL_TYPE  - model type, e.g. adapted or independent"
    echo ""
    echo "eg $0 mfcc reverberated devel features/mfcc/devel"
    echo ""
    exit 1
fi
FEAT_TYPE=$1
MODELNAME=$2
SETNAME=$3
FEAT_ROOT=$4
NUMBER_MIX=$5
MODEL_TYPE=$6

if [ ! -d "$FEAT_ROOT" ]; then
   echo "Error: Unable to access feature directory $FEAT_ROOT"
   exit
fi

TMPID="$FEAT_TYPE.`hostname`.`date +%Y%m%d.%H%M`.$$"
TMPDIR="$REC_ROOT/scripts/tmp"
mkdir -p $TMPDIR
 
flist="$TMPDIR/$SETNAME.$TMPID.list"
ls $FEAT_ROOT | grep $FEAT_TYPE | cut -d. -f1 > $flist
#if [ `cat $flist | wc -l` -lt 600 ]; then
#   echo "Error: Unable to find $FEAT_TYPE features in $FEAT_ROOT"
#   rm -f $flist
#   exit
#fi
head -1 $flist

HMMROOT="$REC_ROOT/models/$MODELNAME"
wdlist="$REC_ROOT/etc/wdlist"
dict="$REC_ROOT/etc/dict"
config="$REC_ROOT/etc/config_train.$FEAT_TYPE"
wdnet="$REC_ROOT/etc/wdnet"
if [ ! -r "$wdnet" ]; then
   # convert grammar into lattice format
   HParse $REC_ROOT/etc/grammar $wdnet
fi

MIX=$NUMBER_MIX

RESDIR="$REC_ROOT/results/${SETNAME}_${MODELNAME}"
mkdir -p $RESDIR
RESFILE="$RESDIR/${SETNAME}_${MODELNAME}.txt"
rm -f $RESFILE

ADAPTED="adapted"
INDEPENDENT="independent"
#echo "Decoding $SETNAME set using $MODELNAME models"
TRACE="0"
# Dynamically generate test list and select HMMs for each speaker ID for Speaker Dependent decoding
echo ""
echo "========================= Performing Recognition ==============================="
for SID in `seq 34`; do
    testlist="$TMPDIR/testlist.id$SID.$TMPID"
#    grep "s${SID}_" $flist | awk '{printf("'$FEAT_ROOT'/%s.'$FEAT_TYPE'\n", $1)}' > $testlist
    awk '{printf("'$FEAT_ROOT'/'id$SID'/%s.'$FEAT_TYPE'\n", $1)}' $REC_ROOT/flists/test_id$SID.list > $testlist
    
# Change lines for speaker adapted and independent
#---------------------------------------------------
# ------- Speaker Adapted ------------------------
if [ "$MODEL_TYPE" = "$ADAPTED" ]; then
    hmms="$HMMROOT/id$SID/hmm$MIX.d/newMacros";

# --------Speaker Independent ----------------------
elif [ "$MODEL_TYPE" = "$INDEPENDENT" ]; then
    hmms="$HMMROOT/SI/hmm$MIX.d/newMacros";

else
    echo "Error: MODEL_TYPE must be: adapted OR independent";
    exit;
fi
# --------------------------------------------------

    if [ ! -r "$hmms" ]; then
        echo "Unable to access HMM file: $hmms"
        rm -f $flist
        exit
    fi
    recogmlf="$TMPDIR/SD_baseline.$TMPID.id$ID.mlf"
    echo "-------- Starting HVite for Speaker $SID --------"
    $CMD_HVite -T $TRACE -C $config -o ST -l '*' -H $hmms -S $testlist -i $recogmlf -w $wdnet $dict $wdlist > /dev/null
    awk -f $REC_ROOT/scripts/fmtmlf.awk $recogmlf >> $RESFILE
#    rm -f $testlist $recogmlf
done
#rm -f $flist

echo "  Results saved in"
echo "    $RESFILE"
ACC=`$REC_ROOT/scripts/do_score.sh $RESFILE`
echo "    Keyword recognition accuracy = ${ACC}%"

