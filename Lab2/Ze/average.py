#!/usr/bin/python

import sys
import os

#Discard 0 values in average
discard_0 = True

#Argument to perform the average
arg = 0
with open(sys.argv[1], "rt") as fin:
	size = 0
	average = 0
	for line in fin:
		parsed = line.split()
		if not (discard_0 and float(parsed[arg])==0):
			size += 1
			average += float(parsed[arg])
#fin.close()

average = average/size
print average
