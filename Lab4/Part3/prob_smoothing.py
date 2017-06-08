#!/usr/bin/python
# coding: iso-8859-1

# Processamento da Fala 2016/2017
# Grupo 8
#

# File to open in this function
# Should be ngrams_s1.txt
def getVocabularySize(fname):
	with open(fname, "rt") as f:
		count = 0
		for line in f:
			count = count + 1;
			if count == 7:
				return line;


def getUnigramFrequency(fname,unigram):
	with open(fname, "rt") as f:
		frequency = 0;
		for line in f:
			unigrams = line.split();
			if unigrams[0] == unigram:
				frequency = unigrams[1];
				return frequency;


def main():
	VocabularySize = getVocabularySize("ngrams_s1.txt")
	UnigramFrequency = getUnigramFrequency("unigrams_s1.txt","é")


if __name__ == "__main__":
	main()
