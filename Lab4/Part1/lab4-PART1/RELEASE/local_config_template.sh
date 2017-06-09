#!/bin/bash

#########################################################################
#                                                                       #
# SPEECH PROCESSING COURSE - Instituto Superior Técnico                 #
# LAB4 - PART 1 - SPEECH PATTERN CLASSIFICATION                         #
# Baseline script for development of a emotion classifier               #
# --------------------------------------------------------------------- #
# Author: Alberto Abad     (alberto.abad@tecnico.ulisboa.pt)            #
# Version: 0.1                                                          #
# Date: 28 April 2017                                                   #
#                                                                       #
#########################################################################


#########################################################################
#                                                                       #
# CONFIGURATION - Change the following paths according to your          #
#                installation                                           #
#                                                                       #
#########################################################################

## Installation configuration
mainDir=`pwd`
toolsDir=$mainDir/tools/
wavDir=$mainDir/data/
labelsDir=$mainDir/labels/
binDir=$mainDir/bin

## Binaries configuration
SMILEbin=$binDir/opensmile-2.3.0/bin/linux_x64_standalone_libstdc6/SMILExtract
SVMTRAINbin=$binDir/libsvm-3.21/bin/svm-train
SVMSCALEbin=$binDir/libsvm-3.21/bin/svm-scale
SVMPREDICTbin=$binDir/libsvm-3.21/bin/svm-predict

#openSMILE configuration file
#RUBEN DEBUG
# openSMILEconfig=$mainDir/config/IS10_paraling.conf


## Output configuration
arffDir=$mainDir/arff/
logsDir=$mainDir/logs/
svmdataDir=$mainDir/svmdata/
modelDir=$mainDir/model/
predictDir=$mainDir/predict/

## Datasets to process
TRAINSET="train"
DEVSET="dev"
# TESTSET="test1"
TESTSET=("test1" "test2")
DATASETS=($TRAINSET $DEVSET ${TESTSET[*]})

#########################################################################
#                                                                       #
# PROCESSING SELECT - Set to 1 the step process that you want to        #
#                run, and to 0 the ones to be skipped                   #
#                                                                       #
#########################################################################

STEP0=1    #  STEP 0 - CLEAN UP directory of previous results
STEP1=1    #  STEP 1 - Extract arff data files for TRAIN, DEV and TEST sets
STEP2=1    #  STEP 2 - Convert arff format files for libsvm format
STEP3=1    #  STEP 3 - Train LIBSVM model
STEP4=1    #  STEP 4 - Generate PREDICTION using dev and test data
