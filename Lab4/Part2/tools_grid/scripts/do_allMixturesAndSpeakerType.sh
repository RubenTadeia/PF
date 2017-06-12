#!/bin/sh
#========================================================
# Script for results for mixtures 3, 5, 7 and speaker independent and adapted
# created by group 8
#========================================================

#set of features to recognize
SET="test/"

echo "##################################################"
echo " "
echo "  RECOGNITION FOR 3 MIX AND SPEAKER INDEPENDENT"
echo " "
echo "##################################################"

./scripts/do_recogInput.sh mfcc train3mix testSI features/mfcc/$SET 3mix independent

echo "##################################################"
echo " "
echo "  RECOGNITION FOR 5 MIX AND SPEAKER INDEPENDENT"
echo " "
echo "##################################################"

./scripts/do_recogInput.sh mfcc train5mix testSI features/mfcc/$SET 5mix independent

echo "##################################################"
echo " "
echo "  RECOGNITION FOR 7 MIX AND SPEAKER INDEPENDENT"
echo " "
echo "##################################################"

./scripts/do_recogInput.sh mfcc train7mix testSI features/mfcc/$SET 7mix independent

echo "##################################################"
echo " "
echo "  RECOGNITION FOR 3 MIX AND SPEAKER ADAPTED"
echo " "
echo "##################################################"

./scripts/do_recogInput.sh mfcc train3mix testSA features/mfcc/$SET 3mix adapted

echo "##################################################"
echo " "
echo "  RECOGNITION FOR 5 MIX AND SPEAKER ADAPTED"
echo " "
echo "##################################################"

./scripts/do_recogInput.sh mfcc train5mix testSA features/mfcc/$SET 5mix adapted

echo "##################################################"
echo " "
echo "  RECOGNITION FOR 7 MIX AND SPEAKER ADAPTED"
echo " "
echo "##################################################"

./scripts/do_recogInput.sh mfcc train7mix testSA features/mfcc/$SET 7mix adapted