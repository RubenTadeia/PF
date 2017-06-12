#!/bin/sh
##########################################################
# The Pascal CHiME Challenge - Keyword Scoring Script    #
#                                                        #
# ASR results need to be stored in the following format: #
# <filename  recognised_letter recognised_digit>         #
# e.g.                                                   #
# s10_bgad7s  p 7                                        #
# s10_brav8p  v 8                                        #
#                                                        #
# Any problem please report to:                          #
# Ning Ma, University of Sheffield, UK                   #
# n.ma@dcs.shef.ac.uk, 17/09/2010                        #
# version 0.1                                            #
##########################################################

if [ ! $# -eq 1 ]; then
    echo "Usage: $0 result_file.txt"
    exit
fi

CWD=`pwd`
cd `dirname $0`/..
REC_ROOT=`pwd`
cd $CWD
 
awk -f $REC_ROOT/scripts/genscore.awk $1

