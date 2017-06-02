#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Processamento da Fala 2016/2017
# Grupo 8
#
import shlex

# Open Training File
with open("s1.txt", "rt") as fin:
	with open("temp.txt", "wt") as fout:

    for line in fin:	    	n="[" + sys.argv[1] + "]"
    	if n in line:
        	fout.write(line.replace(line, ""))
    	else:
    		fout.write(line)


# Open Testing File
#f = open('s2.txt', 'r')
