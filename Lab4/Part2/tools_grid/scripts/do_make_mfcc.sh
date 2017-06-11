#!/bin/sh
##########################################################
# The Pascal CHiME Challenge - Feature Generation Script #
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
# $FEAT_TYPE is the type of feature vectors 
#========================================================
FEAT_TYPE="mfcc"

#========================================================
# Check if HTK binaries are included in $PATH 
#========================================================
CMD_HCopy=`which HCopy`
if [ ! -f $CMD_HCopy ]; then
    echo "Error: Unable to locate HTK tool - HCopy"
    echo "Please add its path into the environment variable PATH"
    exit
fi

#========================================================
# Main Script 
#========================================================
if [ ! $# -eq 2 ]; then
    echo "Usage: $0 WAV_DIR FEAT_DIR"
    echo "       WAV_DIR   - directory that contains wav files"
    echo "       FEAT_DIR  - directory where feature files will be stored"
    exit
fi
WAV_DIR=$1
FEAT_DIR=$2

config="$REC_ROOT/etc/config_code.$FEAT_TYPE"
if [ ! -f $config ]; then
    echo "Unable to access HCopy config file $config"
    exit
fi

if [ ! -d $WAV_DIR ]; then
    echo "Unable to access wav dir $WAV_DIR"
    exit
fi
mkdir -p $FEAT_DIR
if [ ! -d $FEAT_DIR ]; then
    echo "Unable to create feature dir $FEAT_DIR"
    exit 
fi

TMPID="$FEAT_TYPE.`hostname`.`date +%Y%m%d.%H%M`.$$"
TMPDIR="$REC_ROOT/scripts/tmp"
mkdir -p $TMPDIR

flist="$TMPDIR/feature_list.$TMPID"
ls $WAV_DIR | grep wav$ | sed 's/\.wav$//' > $flist

listscp="$TMPDIR/hcopy_$SETNAME.$TMPID.scp"
awk '{printf("'$WAV_DIR'/%s.wav '$FEAT_DIR'/%s.'$FEAT_TYPE'\n", $1, $1)}' $flist > $listscp
$CMD_HCopy -T 0 -C $config -S $listscp

# House cleaning
rm -f $listscp $flist

