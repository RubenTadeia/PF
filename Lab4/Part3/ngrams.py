#!/usr/bin/python
# coding: iso-8859-1

# Processamento da Fala 2016/2017
# Grupo 8

import operator # Import for sorting
import sys

# In this function we open the unigrams file
# previously created and we create the unigrams file
def doUnigrams(fNameIn, fNameOut):
	#Dictionary of unigrams
	unigrams={}

	# Open Training File
	with open(fNameIn, "rt") as fin:

		for line in fin:
			words=line.split()
			for word in words:
				if word in unigrams:
					unigrams[word] += 1
				else:
					unigrams[word] = 1


	#Sorting by value
	sortedUnigrams = reversed(sorted(unigrams.items(), key=operator.itemgetter(1)))

	#Writing sorted unigrams to file
	with open(fNameOut, "wt") as fout:
		numberUnigramsToPrint=10
		n=0
		frequentUnigrams=[]
		for k in sortedUnigrams:
			unigram=str(k[0]) + " " + str(k[1]) # Add _ between the 2 words of the bigram
			if n < numberUnigramsToPrint:
				print unigram
				frequentUnigrams.append(unigram)
				n += 1
			fout.write(unigram + "\n")

	return frequentUnigrams


# In this function we open the bigrams file
# then we create the bigrams file
def doBigrams(fNameIn, fNameOut):

	#Dictionary of bigrams
	bigrams={}

	# Open Training File
	with open(fNameIn, "rt") as fin:

		for line in fin:
			words = line.split()
			for i in range(0, len(words)-1):
				bigram = words[i] + "_" + words[i+1] # Add _ between the 2 words of the bigram

				if bigram in bigrams:
					bigrams[bigram] += 1
				else:
					bigrams[bigram] = 1


	#Sorting by value
	sortedBigrams = reversed(sorted(bigrams.items(), key=operator.itemgetter(1)))

	#Writing sorted unigrams to file
	with open(fNameOut, "wt") as fout:
		numberBigramsToPrint=10
		n=0
		frequentBigrams=[]
		for k in sortedBigrams:
			bigram=str(k[0]) + " " + str(k[1])
			if n < numberBigramsToPrint:
				print bigram
				frequentBigrams.append(bigram)
				n += 1
			fout.write(bigram + "\n")

	return frequentBigrams


# Function that counts the size of the vocabulary
# given the initial training file as input
def doVocabularySize(fname):
	with open(fname, "rt") as f:
		for i, l in enumerate(f):
			pass
	return i + 1


# In this function we create the output file from a template
# we even fillthe file with all the information that he needs
def doOutputFile(frequentUnigrams, frequentBigrams, numberUnigrams, numberBigrams, vocabSize, outputFilename):

	separator = "-" * 45
	with open(outputFilename, "wt") as fout:
		fout.write(separator); fout.write("\n"); fout.write("\n")
		fout.write("Made by Group 8:\n")

		fout.write("\n")
		fout.write(separator); fout.write("\n"); fout.write("\n")
		fout.write("Vocabulary size:\n")
		fout.write(str(vocabSize)+"\n")

		fout.write("\n")
		fout.write(separator); fout.write("\n"); fout.write("\n")
		fout.write("Number of unigrams\n")
		fout.write(str(numberUnigrams)+"\n")

		fout.write("\n")
		fout.write(separator); fout.write("\n"); fout.write("\n")
		fout.write("10 most frequent unigrams\n")
		for i in frequentUnigrams:
			fout.write(i+"\n")

		fout.write("\n")
		fout.write(separator); fout.write("\n"); fout.write("\n")
		fout.write("Number of bigrams\n")
		fout.write(str(numberBigrams)+"\n")

		fout.write("\n")
		fout.write(separator); fout.write("\n"); fout.write("\n")
		fout.write("10 most frequent bigrams\n")
		for i in frequentBigrams:
			fout.write(i+"\n")

		fout.write("\n")
		fout.write(separator); fout.write("\n");


# Function that return the number of Ngrams
def numberOfNgrams(fname):
	with open(fname, "rt") as f:
		count = 0
		for line in f:
			value = line.split()
			count += int(value[1])
	return count

# The main function calls the previously created functions
# Calculates the probability to be shown in the outputFile
# creates the outputFile and writes in it
# If no input file is given upon execution, there will be thrown an error
def main():
	if len(sys.argv) != 1: # Verification that input training file is provided
		unigramsFilename = "unigrams_" + sys.argv[1];
		bigramsFilename = "bigrams_" + sys.argv[1];
		outputFilename  = "ngrams_" + sys.argv[1];
		frequentUnigrams = doUnigrams(sys.argv[1], unigramsFilename)
		frequentBigrams = doBigrams(sys.argv[1], bigramsFilename)
		numberUnigrams = numberOfNgrams(unigramsFilename)
		numberBigrams = numberOfNgrams(bigramsFilename)
		vocabSize = doVocabularySize(unigramsFilename)
		doOutputFile(frequentUnigrams, frequentBigrams, numberUnigrams, numberBigrams, vocabSize, outputFilename)
	else:
		print "";
		print "[ERROR] How to run it: python ngrams.py <trainingFile.txt>";
		print "";

if __name__ == "__main__":
	main()
