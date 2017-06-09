#!/usr/bin/python
# coding: iso-8859-1

# Processamento da Fala 2016/2017
# Grupo 8

import sys

# This function opens the unigram file that has been created
# previously using the ngrams.py script, after opening the file
# retrieves the frequency of a given unigram (input)
def getUnigramFrequency(unigramsFile,unigram):
	with open(unigramsFile, "rt") as f:
		frequency = 0;
		for line in f:
			unigrams = line.split();
			if unigrams[0] == unigram:
				frequency = unigrams[1];
				return frequency;

# This function opens the bigram file that has been created
# previously using the ngrams.py script, after opening the file
# retrieves the frequency of a given bigram (input)
def getBigramFrequency(bigramsFile,bigram):
	with open(bigramsFile, "rt") as f:
		frequency = 0;
		for line in f:
			bigrams = line.split();
			if bigrams[0] == bigram:
				frequency = bigrams[1];
				return frequency;

# Function that returns the size of the vocabulary
# given the initial file as input
def getVocabularySize(fname):
	iterator = 0;
	with open(fname, "rt") as f:
		for line in f:
			iterator = iterator + 1 ;
			if iterator == 8:
				return line

# This function calculates the final probability to be
# shown in the output file. 
# In the process some auxiliar variables containing the unigrams
# and the bigrams are used to ensure that the outputFile is written as 
# it is supposed to be !
def getBigramProbability(testFile):
	with open(testFile, "rt") as f:
		probability = 1;
		VocabularySize = getVocabularySize("ngrams_s1.txt");
		vocabularyAuxiliar = VocabularySize.split('\n') # This variable is used to remove the \n
		VocabularySize = vocabularyAuxiliar[0];
		outputFileName = "prob_smoothing_" + testFile;
		templateToWrite = "C(%s) = %s\nC(%s) = %s\nParcial Probability_%d (%s|%s) = ( %s + 1 ) / ( %s + %s ) = %.12g\n\n"
		finalTemplateToWrite = "\nFinal Probability is given by:\nP[%s] = %.12g\n"
		portion = 0.0; # Portion is a variable that stores
				# the small value of probability to calculate
		for line in f:
			frequencyBigram = 0;
			frequencyUnigram = 0;
			iterator = 1;
			words = line.split()
			testSentence = line.split('\n')
			insertLineOutputFile(outputFileName, "Compute P("+ testSentence[0] +")");
			insertLineOutputFile(outputFileName, "\n");
			for i in range(0, len(words)-1):
				bigram = words[i] + "_" + words[i+1]
				print "bigram = " + bigram;
				print "unigram = " + words[i];

				print "Vocabulary Size = " + VocabularySize;
				frequencyBigram = getBigramFrequency("bigrams_s1.txt",bigram);
				print "frequency of bigram = "+ frequencyBigram;

				frequencyUnigram = getUnigramFrequency("unigrams_s1.txt",words[i]);
				print "frequency of unigram = "+ frequencyUnigram;

				portion = (float(frequencyBigram) + 1.0) / (float(frequencyUnigram) + float(VocabularySize));
				print "parcial probability = ", portion;


				bigramSpaced = bigram.replace('_', ',')

				insertLineOutputFile(outputFileName,"Vocabulary Size = "+VocabularySize);

				lineToWrite = templateToWrite % (bigramSpaced, frequencyBigram,
				words[i],frequencyUnigram,iterator,words[i+1], words[i],
				frequencyBigram ,frequencyUnigram, VocabularySize, portion);

				iterator = iterator + 1;
				insertLineOutputFile(outputFileName,lineToWrite);
				probability = probability * portion;
				print "";

			lineToWrite = finalTemplateToWrite % (testSentence[0], probability);
			insertLineOutputFile(outputFileName,lineToWrite);

	return probability;

# This function creates the outputFile 
def doOutputFile(inputFile):
	separator = "-" * 158
	outputFileName = "prob_smoothing_" + inputFile;
	with open(outputFileName, "wt") as fout:
		fout.write(separator)
		fout.write("\n");fout.write("\n");
		fout.write("Made by Group 8:\n")
		fout.write("\n")

		fout.write(separator)
		fout.write("\n");fout.write("\n");
		fout.write("Computing the probability of the given test sentence from the file "+ inputFile +"\n")
		fout.write("With Add-One Smoothing with the language model based on the Training\n")
		fout.write("file s1.txt\n")
		fout.write("\n")

		fout.write(separator)
		fout.write("\n");fout.write("\n");
		fout.write("The Probability With Add-One Smoothing Formula was calculated this way:"+"\n")
		fout.write("\nProbability(With Add-One Smoothing) = ∑_para_todos_os_bigramas (#ocorrências_do_bigrama + 1)"+
		 " / (#ocorrências_da_primeira_palavra_do_bigrama + VocabularySize)\n")
		fout.write("\n")
		fout.write(separator)
		fout.write("\n");fout.write("\n");

# This function appends one given line (input)
# to the previously created outputFile
def insertLineOutputFile(outputFileName,line):

	with open(outputFileName, "a") as fout:
		fout.write(line)
		fout.write("\n")

# The main function calls the previously created functions
# Calculates the probability to be shown in the outputFile
# creates the outputFile and writes in it
# If no input file is given upon execution, there will be thrown an error
def main():
	if len(sys.argv) != 1: # Verification that input test file is provided
		separator = "-" * 158
		doOutputFile(sys.argv[1]);
		probability = getBigramProbability(sys.argv[1]);
		outputFileName = "prob_smoothing_" + sys.argv[1];
		insertLineOutputFile(outputFileName,separator);
		print "final probability = ", probability;
	else:
		print "";
		print "[ERROR] How to run it: python prob_smoothing.py <testFile.txt>";
		print "";

if __name__ == "__main__":
	main()
