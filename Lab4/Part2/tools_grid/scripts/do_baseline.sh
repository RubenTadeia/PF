#!/bin/sh
#========================================================
# BASELINE script for initial execution for speaker adapted with 3 mix models
# created by group 8
#========================================================

echo "##################################################"
echo " "
echo "           BUILD FLISTS FROM TRAIN DATA"
echo " "
echo "##################################################"

./scripts/build_flists_train.sh

echo "##################################################"
echo " "
echo "           BUILD FLISTS FROM TEST DATA"
echo " "
echo "##################################################"

./scripts/build_flists_test.sh

echo "##################################################"
echo " "
echo "       EXTRACT MFCC FEATURES FROM TRAIN DATA"
echo " "
echo "##################################################"

./scripts/do_mfcc_train.sh

echo "##################################################"
echo " "
echo "       EXTRACT MFCC FEATURES FROM TEST DATA"
echo " "
echo "##################################################"

./scripts/do_mfcc_test.sh

echo "##################################################"
echo " "
echo "             DO TRAIN FROM TRAIN DATA"
echo " "
echo "##################################################"

./scripts/do_train.sh train3mix mfcc features/mfcc/train

echo "##################################################"
echo " "
echo "          DO RECOGNITION FROM TEST DATA"
echo " "
echo "##################################################"

./scripts/do_recog.sh mfcc train3mix testSA features/mfcc/test/