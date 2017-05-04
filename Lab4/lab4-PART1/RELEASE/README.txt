#########################################################################
#                                                                       #
# SPEECH PROCESSING COURSE - Instituto Superior Técnico                 #
# LAB4 - PART 1 - SPEECH PATTERN CLASSIFICATION CHALLENGE               #
#                                                                       #
#########################################################################

== 1. INTRODUCTION == 

The objective of these laboratory sessions is to practice some of the 
concepts introduced in Chapter 5: Speech Pattern Classification. To this 
end, the students will have to develop an automatic emotion classifier 
using a speech corpus provided by the professors. In addition to the 
training data set, a development data set (with the corresponding labels) 
and possibly more than one different blind test sets will be provided. 
The students will be asked to submit their predictions of the test set 
(it is possible to submit up to 5 different systems) and a brief 
description of the work done. All the submissions will be ranked and the 
best results will be announced in a post-challenge session. 
Students are encouraged to use any feature extraction method or machine 
learning toolkit to develop their systems. At this regard, some useful 
links can be found in the theory notes of Chapter 5 that can be found in 
https://www.l2f.inesc-id.pt/~imt/priv/pf/en_pf/pattern_intro.html. 
Nevertheless, a baseline system consisting of OpenSMILE + libSVM is 
provided by the professors. The baseline works in Linux.

== 2. DATA AND BASELINE ==
All the necessary files, including data and the baseline system, can be 
found in: http://www.l2f.inesc-id.pt/~alberto/PF/2016-2017/lab4-PART1.tgz

This compressed file contains the following files and directories:

./LAB4_BASELINE.sh   is the main script to run the baseline system

./local_config.sh    contains the local folder configuration and the 
                     processing step selection

./bin/               contains the binaries of OpenSMILE v2.3.0 and 
                     libSVM v3.2.1 (contact the professor if these do not 
                     work)
                     
./config/            contains OpenSMILE config files used by the baseline 
                     system
                     
./data/              contains wav files split in train, dev and test 
                     folders (not all files are actually used in the 
                     challenge)

./labels/            contains the file lists for train, dev and test and 
                     the corresponding labels
                     
./tools/             contains data processing tools

In order to run the baseline you need a Linux machine. Then, you will need 
to edit some of the variables of the ./local_config.sh script. Then, simply 
run the script and wait (the feature extraction process can be long). The 
final result should be a <dataset>.result.txt,  corresponding to the 
predictions of the baseline for each development and test data set. 
These files look like this:

qknt25ya67 neutral 
y8jcuznm1w neutral 
u0t4cmaeu6 neutral 
g4tq8cfxun angry 
56sjp3ksit neutral

where the first colum corresponds to the file identifier and the second one 
to the identified class (neutral or angry). There may be a third optional 
column with a confidence value. The script allows for skipping easily some 
of the intermediate STEPS setting the addequate variable to 0.

== WORK TO DO IN THIS LAB ==

1. Run the baseline

2. Improve the baseline (free)

3. Submit your decisions and your system/experiments description (information 
about the submission process will be announced)
