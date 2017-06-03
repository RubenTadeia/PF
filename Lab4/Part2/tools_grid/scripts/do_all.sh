#!/bin/sh
#========================================================
# $REC_ROOT is the directory of the baseline recogniser 
#========================================================
CWD=`pwd`
cd `dirname $0`/..
REC_ROOT=`pwd`
cd $CWD

#========================================================
# Main Script 
#========================================================

echo "##################################################"
echo " "
echo "              DO_MAKE_MFCC TRAIN DATA"
echo " "
echo "##################################################"

./scripts/do_make_mfcc.sh data/train features

echo "##################################################"
echo " "
echo "              DO_TRAIN FROM TRAIN"
echo " "
echo "##################################################"

./scripts/do_train.sh train2 mfcc features

echo "##################################################"
echo " "
echo "              DO_MAKE_MFCC TEST DATA"
echo " "
echo "##################################################"

./scripts/do_make_mfcc.sh data/test features

echo "##################################################"
echo " "
echo "              DO_RECOG TRAINING SET"
echo " "
echo "##################################################"

./scripts/do_recog.sh mfcc train2 training features

#-------------------------------------------------------------------------------------------------

# echo "##################################################"
# echo " "
# echo "              DO_MAKE_MFCC TEST DATA"
# echo " "
# echo "##################################################"

# ./scripts/do_make_mfcc.sh data/test features

# echo "##################################################"
# echo " "
# echo "              DO_TRAIN FROM TEST"
# echo " "
# echo "##################################################"

# ./scripts/do_train.sh test mfcc features

# echo "##################################################"
# echo " "
# echo "              DO_RECOG TESTING SET"
# echo " "
# echo "##################################################"

# ./scripts/do_recog.sh mfcc test testing features

#-------------------------------------------------------------------------------------------------

# echo "##################################################"
# echo " "
# echo "              DO_MAKE_MFCC DEV DATA"
# echo " "
# echo "##################################################"

# ./scripts/do_make_mfcc.sh data/dev features

# echo "##################################################"
# echo " "
# echo "              DO_TRAIN FROM DEV"
# echo " "
# echo "##################################################"

# ./scripts/do_train.sh dev mfcc features

# echo "##################################################"
# echo " "
# echo "              DO_RECOG TESTING SET"
# echo " "
# echo "##################################################"

# ./scripts/do_recog.sh mfcc dev deving features