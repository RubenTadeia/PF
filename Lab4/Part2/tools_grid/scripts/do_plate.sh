#!/bin/sh

#========================================================
# PLATE script to extract features, parse, recognize and save results for plates
# created by group 8
#========================================================

MIX="3mix"
MODELNAME="train""$MIX"
REC_ROOT=`pwd`
RESFILE="$REC_ROOT/results/plateSI_${MIX}_${MODELNAME}.txt"
echo "" > $RESFILE
idTemplate="id"

# for PLATE in "id1/52fa71" "id2/43po21"
for PLATE in `find $REC_ROOT/data/test2/ -name \*.wav -print`
do
	LENGTH=`expr length $PLATE`
	INDEX=$(($LENGTH-13))
	PLATE=`expr substr $PLATE $INDEX 10`
	
	echo "########### PLATE: $PLATE ###########"

	echo "------------------------- HCopy -------------------------------"
	HCopy -T 0 -C etc/config_code.mfcc data/test2/$PLATE.wav features/mfcc/test2/$PLATE.mfcc

	echo "------------------------- HParse -------------------------------"
	HParse etc/grammar2 etc/wdnet2

	echo "------------------------- HVite -------------------------------"
	HVite -T 0 -C etc/config_train.mfcc -o ST -l '*' -H models/$MODELNAME/SI/hmm$MIX.d/newMacros -i labels/$PLATE.mlf -w etc/wdnet2 etc/dict2 etc/wdlist2 features/mfcc/test2/$PLATE.mfcc

	echo "------------------------- Save results -------------------------------"
	plate=`expr substr $PLATE 5 6`
	
	awk -f $REC_ROOT/scripts/fmtmlf.awk $REC_ROOT/labels/$PLATE.mlf >> $RESFILE

done

ACC=`$REC_ROOT/scripts/do_score.sh $RESFILE`
	echo "    Keyword recognition accuracy = ${ACC}%"
	echo "    Keyword recognition accuracy = ${ACC}%" >> $RESFILE