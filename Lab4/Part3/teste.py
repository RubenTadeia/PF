# Processamento da Fala 2016/2017
# Grupo 8

import shlex

# Open Training File
f =  open("s1.txt", "r")

count = {}

for word in shlex.split(f):
	if word in count :
		count[word] += 1
	else:
		count[word] = 1
print count
