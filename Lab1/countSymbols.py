#!/usr/bin/python

import sys
import os
from array import *

phoneticSymbols = {"a": 0, "E": 0, "i": 0, "O": 0, "u": 0, "e": 0, "6": 0, "@": 0, "o": 0, "i~": 0, "e~": 0, "6~": 0, "o~": 0, "u~": 0, "j": 0, "w": 0, "j~": 0, "w~": 0, "%": 0, "$": 0, "p": 0, "t": 0, "k": 0, "b": 0, "d": 0, "g": 0, "f": 0, "s": 0, "S": 0, "v": 0, "z": 0, "Z": 0, "l": 0, "l~": 0, "L": 0, "r": 0, "R": 0, "m": 0, "n": 0, "J": 0, "~": 0}

waiting = False
#Count phonetic symbols
with open(sys.argv[1], "rt") as file:
    for line in file:
    	inv = line[::-1]
    	for c in inv:
	    	if c in phoneticSymbols:
	        	if waiting == True:
	        		n = c + "~"
	           		try:
	        			phoneticSymbols[n] = phoneticSymbols[n] + 1
	        		except KeyError, e:
	        			print "Phonetic Symbol Error: %s :: %s" % (str(n), str(e))
	        		waiting = False
	        	elif c == '~':
	        		waiting = True
	        	else:
	        		try:
	        			phoneticSymbols[c] = phoneticSymbols[c] + 1
	        		except KeyError, e:
	        			print "Phonetic Symbol Error: %s :: %s" % (str(n), str(e))

#PrettyPrint
# highest = 0
# for symbol in phoneticSymbols:
# 	if phoneticSymbols[symbol] > highest:
# 		highest = 

#print phoneticSymbols
for c in phoneticSymbols:
	if phoneticSymbols[c] != 0:
		print "%s :: %s" % (c, phoneticSymbols[c])

print "MAX: " + max(phoneticSymbols, key=lambda i: phoneticSymbols[i])