#!/bin/bash

#########################################################################
#                                                                       #
# SPEECH PROCESSING COURSE - Instituto Superior T�cnico                 #
# LAB4 - PART 1 - SPEECH PATTERN CLASSIFICATION                         #
# Baseline script for development of a emotion classifier               #
# --------------------------------------------------------------------- #
# Author: Alberto Abad     (alberto.abad@tecnico.ulisboa.pt)            #
# Version: 0.1                                                          #
# Date: 28 April 2017                                                   #
#                                                                       #
#########################################################################

. ./local_config.sh


#########################################################################
#                                                                       #
# STEP 0 - CLEAN UP directory of previous results                       #
#                                                                       #
#########################################################################
if [ $STEP0 -eq "1" ]; then
  echo "STEP 0 - CLEAN UP directory of previous results"

  rm -rf $predictDir $modelDir $svmdataDir $logsDir $arffDir
  for dataset in ${DEVSET[*]} ${TESTSET[*]}; do
    touch $dataset.result.txt
    rm $dataset.result.txt
  done
fi


mkdir -p $logsDir
#########################################################################
#                                                                       #
# STEP 1 - Extract arff data files for TRAIN, DEV and TEST sets         #
#                                                                       #
#########################################################################

if [ $STEP1 -eq "1" ]; then
  echo "STEP 1 - Extract arff data files for TRAIN, DEV and TEST sets"

  mkdir -p $arffDir
  for dataset in ${DATASETS[*]}; do

    list=$labelsDir/${dataset}_labels.txt

    touch $arffDir/$dataset.arff
    rm $arffDir/$dataset.arff

    while read line; do
      base=`echo $line | cut -d' ' -f1`
      label=`echo $line | cut -d' ' -f2`

      $SMILEbin -C $openSMILEconfig -I $wavDir/$dataset/$base.wav -O $arffDir/$dataset.arff -class $label -N $base -noconsoleoutput

      mv smile.log $logsDir/$dataset.$base.smile.log
    done < $list

  done
else
  echo "SKIP STEP 1!!!"
fi


#########################################################################
#                                                                       #
# STEP 2 - Convert arff format files for libsvm format                  #
#                                                                       #
#########################################################################

if [ $STEP2 -eq "1" ]; then

  echo "STEP 2 - Convert arff format files for libsvm format"

  mkdir -p $svmdataDir $modelDir

  for dataset in ${DATASETS[*]}; do

    ##hack to change the header to be compatible with WEKA
    sed -i -e "s/@attribute class numeric/@attribute Emotion {neutral,angry}/g" $arffDir/$dataset.arff

    touch $svmdataDir/$dataset.datasvm
    rm $svmdataDir/$dataset.datasvm

    grep -v "^$" $arffDir/$dataset.arff  | grep -v ^@ | cut -d, -f2- | perl $toolsDir/arff2svm.py $logsDir/$dataset.convert.log -  $svmdataDir/$dataset.datasvm
    sort $logsDir/$dataset.convert.log > $logsDir/$dataset.convert.log.tmp; mv $logsDir/$dataset.convert.log.tmp $logsDir/$dataset.convert.log
  done


  ## SCALE DATA
  $SVMSCALEbin -s $modelDir/scaling.conf $svmdataDir/$TRAINSET.datasvm 1> $svmdataDir/$TRAINSET.datasvmscale 2> $logsDir/$TRAINSET.svmscale.log
  for dataset in ${DEVSET[*]} ${TESTSET[*]}; do
    $SVMSCALEbin -r $modelDir/scaling.conf $svmdataDir/$dataset.datasvm 1> $svmdataDir/$dataset.datasvmscale 2>  $logsDir/$dataset.svmscale.log
  done


  ## SANITY CHECK
  for dataset in ${DEVSET[*]}; do
    check=`diff $logsDir/$TRAINSET.convert.log $logsDir/$dataset.convert.log`
    if [ ! -z "$check" ]; then
        echo "Inconsistent TRAIN and $dataset label numbering -- CORRECT!!"
        exit
    fi
  done


else
  echo "SKIP STEP 2!!!"
fi



#########################################################################
#                                                                       #
# STEP 3 - Train LIBSVM model                                           #
#                                                                       #
#########################################################################
data=datasvmscale
if [ $STEP3 -eq "1" ]; then
  echo "STEP 3 - Train LIBSVM model "
  mkdir -p  $modelDir

  $SVMTRAINbin -t 0 $svmdataDir/$TRAINSET.$data $modelDir/emotion_model.svm
else
  echo "SKIP STEP 3!!!"
fi

#########################################################################
#                                                                       #
# STEP 4 - Generate PREDICTION using dev and test data                  #
#                                                                       #
#########################################################################

if [ $STEP4 -eq "1" ]; then
  echo "STEP 4 - Generate predictions "
  mkdir -p $predictDir
  for dataset in ${DEVSET[*]} ${TESTSET[*]}; do

    $SVMPREDICTbin $svmdataDir/$dataset.$data $modelDir/emotion_model.svm $predictDir/$dataset.svmprediction >& /dev/null

    cat $logsDir/$TRAINSET.convert.log $predictDir/$dataset.svmprediction  | grep -v labels | awk '{if (NF==2) id[$1]=$2; else {print id[$1], $($1+1)}}'  | paste -d' ' $labelsDir/${dataset}_labels.txt - | cut -d' ' -f1,3- > $dataset.result.txt

  done


  for dataset in ${DEVSET[*]} ${TESTSET[*]}; do
    echo "Accuracy on the $dataset set `paste -d' ' $labelsDir/${dataset}_labels.txt $dataset.result.txt | awk 'BEGIN{acc=0;}{if ($2==$4) acc++;}END{print 100*acc/NR"% ("acc"/"NR")"}'`"
  done

else
  echo "SKIP STEP 4!!!"
fi
