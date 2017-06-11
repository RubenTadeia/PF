#!/bin/sh
##########################################################
# The 2nd CHiME Challenge - Model Training Script        #
#                                                        #
# Estimate Speaker Dependent HMMs                        #
#                                                        #
# Authored by Ning Ma, University of Sheffield, and      #
# modified by Emmanuel Vincent, INRIA                    #
#                                                        #
# Any problem please report to emmanuel.vincent@inria.fr #
# Version 0.2, July 6, 2012                              #
##########################################################

#========================================================
# $REC_ROOT is the directory of the baseline recogniser 
#========================================================
CWD=`pwd`
cd `dirname $0`/..
REC_ROOT=`pwd`
cd $CWD

#========================================================
# Check if HTK binaries exist
#========================================================
CMD_HERest=`which HERest`
CMD_HCompV=`which HCompV`
CMD_HHEd=`which HHEd`
if [ ! -f $CMD_HERest ]; then
    echo "Error: Unable to locate HTK tool - HERest"
    echo "Please add its path into the environment variable PATH"
    exit
fi
if [ ! -f $CMD_HCompV ]; then
    echo "Error: Unable to locate HTK tool - HCompV"
    echo "Please add its path into the environment variable PATH"
    exit
fi
if [ ! -f $CMD_HHEd ]; then
    echo "Error: Unable to locate HTK tool - HHEd"
    echo "Please add its path into the environment variable PATH"
    exit
fi

#========================================================
# Main Script 
#========================================================
if [ ! $# -eq 3 ]; then
    echo ""
    echo "Usage: $0 MODELNAME FEAT_TYPE FEAT_ROOT"
    echo "       MODELNAME  - Unique ID for the resulting models"
    echo "       FEAT_TYPE  - feature type, e.g. mfcc"
    echo "       FEAT_ROOT  - feature directory that contains sub-directories id1, id2..."
    echo ""
    echo "eg $0 reverberated mfcc features/mfcc/train_reverberated"
    echo ""
    exit 1
fi
MODELNAME=$1
FEAT_TYPE=$2
FEAT_ROOT=$3
if [ ! -d "$FEAT_ROOT" ]; then
   echo "Error: Unable to access $FEAT_TYPE features in $FEAT_ROOT"
   exit 1
fi

vFloor="0.01"
HMMROOT="$REC_ROOT/models/$MODELNAME/SI"
config="$REC_ROOT/etc/config_train.$FEAT_TYPE"
wdlist="$REC_ROOT/etc/wdlist"
labelmlf="$REC_ROOT/labels/allids.mlf"

TMPDIR="$REC_ROOT/scripts/tmp"
TMPID="$FEAT_TYPE.`hostname`.`date +%Y%m%d.%H%M`.$$"

TRACE="0"

# Change here too
SDMIX="3"

SIHMM="$HMMROOT/hmm${SDMIX}mix.d/newMacros"
#if [ ! -r $SIHMM ]; then #----SIHMM

trainlist="$TMPDIR/trainlist.$TMPID"
awk '{printf("'$FEAT_ROOT'/%s.'$FEAT_TYPE'\n", $1)}' $REC_ROOT/flists/train_allids.list > $trainlist

#=================================================================================
# HTK Training
#=================================================================================
# Initialise prototype 4, 6, 8 and 10 state models.
echo "========================= Using HCompV to initialise models ========================"
# Produce seed HMM
# Generate initial HMM "hmmdef" with global data means and variances
#
curdir="$HMMROOT/hmm1mix.0"
mkdir -p $curdir
echo "    HCompV for 4-state models"
$CMD_HCompV -v $vFloor -C $config -T $TRACE -S $trainlist -m -o m4states -M $curdir $REC_ROOT/etc/proto.4states.$FEAT_TYPE
echo "    HCompV for 6-state models"
$CMD_HCompV -v $vFloor -C $config -T $TRACE -S $trainlist -m -o m6states -M $curdir $REC_ROOT/etc/proto.6states.$FEAT_TYPE
echo "    HCompV for 8-state models"
$CMD_HCompV -v $vFloor -C $config -T $TRACE -S $trainlist -m -o m8states -M $curdir $REC_ROOT/etc/proto.8states.$FEAT_TYPE
echo "    HCompV for 10-state models"
$CMD_HCompV -v $vFloor -C $config -T $TRACE -S $trainlist -m -o m10states -M $curdir $REC_ROOT/etc/proto.10states.$FEAT_TYPE
echo "    Seed Hmm successfully produced..."

# make initial 4-state models
for mod in at by in a b c d e f g h i j k l m n o p q r s t u v x y z one two three eight sil; do
    sed "s/m4states/$mod/g" $curdir/m4states > $curdir/$mod
done
# make initial 6-state models
for mod in bin lay place set blue green red white with four five six nine now please soon; do
    sed "s/m6states/$mod/g" $curdir/m6states > $curdir/$mod
done
# make initial 8-state models
for mod in again zero; do
    sed "s/m8states/$mod/g" $curdir/m8states > $curdir/$mod
done
# make initial 10-state models
for mod in seven; do
    sed "s/m10states/$mod/g" $curdir/m10states > $curdir/$mod
done

echo ""
echo "========================= Performing HERest and HHEd ==============================="
echo "-------- Starting HERest for 1 mix models --------"

prevdir="$curdir"
curdir="$HMMROOT/hmm1mix.a"
mkdir -p $curdir
echo "    HERest pass a..."
$CMD_HERest -C $config -I $labelmlf -T $TRACE -S $trainlist -d $prevdir -M $curdir $wdlist
echo "    Done!"
prevpass="a"
for pass in b c d; do
    echo "    HERest pass $pass..."
    prevdir="$HMMROOT/hmm1mix.$prevpass"
    curdir="$HMMROOT/hmm1mix.$pass"
    mkdir -p $curdir
    $CMD_HERest -C $config -I $labelmlf -T $TRACE -S $trainlist -d $prevdir -H $prevdir/newMacros -M $curdir $wdlist
    echo "    Done!"
    prevpass=$pass
done
rm -rf $HMMROOT/hmm1mix.0 $HMMROOT/hmm1mix.a $HMMROOT/hmm1mix.b $HMMROOT/hmm1mix.c

prevdir="$curdir"
# for mix in 2 3 5 7; do
# for mix in 2 3 5; do
for mix in 2 3; do
    echo ""
    echo "    Splitting the models to $mix mix..."
    curdir=$HMMROOT/hmm${mix}mix.0
    mkdir -p $curdir
    $CMD_HHEd -C $config -d $prevdir -H $prevdir/newMacros -M $curdir $REC_ROOT/etc/mix${mix}.hed $wdlist
    echo "    Done!"
    echo ""
    echo "-------- Starting HERest for $mix mix models --------"
    prevpass=0
    for pass in a b c d; do
        echo "    HERest pass $pass..."
        prevdir="$HMMROOT/hmm${mix}mix.$prevpass"
        curdir="$HMMROOT/hmm${mix}mix.$pass"
        mkdir -p $curdir
        $CMD_HERest -C $config -I $labelmlf -T $TRACE -S $trainlist -d $prevdir -H $prevdir/newMacros -M $curdir $wdlist
        echo "    Done!"
        prevpass=$pass
    done
    prevdir=$curdir
    rm -rf $HMMROOT/hmm${mix}mix.0 $HMMROOT/hmm${mix}mix.a $HMMROOT/hmm${mix}mix.b $HMMROOT/hmm${mix}mix.c
done

#fi #----SIHMM

echo ""
echo "====================== Creating Speaker Dependent Models ==========================="
for SID in `seq 34`; do
    echo ""
    echo "-------- Adapting models for Speaker $SID --------"
    SDFEAT_ROOT="$FEAT_ROOT/id$SID"
    SDHMMROOT="$REC_ROOT/models/$MODELNAME/id$SID"
    mkdir -p $SDHMMROOT
    labelmlf="$REC_ROOT/labels/id$SID.mlf"
    trainlist="$TMPDIR/trainlist_id$SID.$TMPID"
    awk '{printf("'$SDFEAT_ROOT'/%s.'$FEAT_TYPE'\n", $1)}' $REC_ROOT/flists/train_id$SID.list > $trainlist
    echo ""
    echo "    Copying $SDMIX mix speaker independent models..."
    curdir=$SDHMMROOT/hmm${SDMIX}mix.0
    mkdir -p $curdir
    cp $SIHMM $curdir
    echo "    Done!"
    echo ""
    echo "-------- Starting HERest for ${SDMIX} mix speaker dependent models --------"
    prevpass=0
    for pass in a b c d; do
        echo "    HERest pass $pass..."
        prevdir="$SDHMMROOT/hmm${SDMIX}mix.$prevpass"
        curdir="$SDHMMROOT/hmm${SDMIX}mix.$pass"
        mkdir -p $curdir
        $CMD_HERest -C $config -I $labelmlf -T $TRACE -S $trainlist -d $prevdir -H $prevdir/newMacros -M $curdir $wdlist
        echo "    Done!"
        prevpass=$pass
    done
    prevdir=$curdir

    rm -rf $SDHMMROOT/hmm${SDMIX}mix.0 $SDHMMROOT/hmm${SDMIX}mix.a $SDHMMROOT/hmm${SDMIX}mix.b $SDHMMROOT/hmm${SDMIX}mix.c
done

# Cleaning up
rm -f $trainlist

echo "----------------------------------------------------------"
echo "Model files are saved in $REC_ROOT/models/$MODELNAME"

