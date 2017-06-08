#!/usr/bin/python
# coding: iso-8859-1

# Processamento da Fala 2016/2017
# Grupo 8
#

import sys

def getUnigramFrequency(unigramsFile,unigram):
	with open(unigramsFile, "rt") as f:
		frequency = 0;
		for line in f:
			unigrams = line.split();
			if unigrams[0] == unigram:
				frequency = unigrams[1];
				return frequency;

def getBigramFrequency(bigramsFile,bigram):
	with open(bigramsFile, "rt") as f:
		frequency = 0;
		for line in f:
			bigrams = line.split();
			if bigrams[0] == bigram:
				frequency = bigrams[1];
				return frequency;

def getBigramProbability(testFile):
	with open(testFile, "rt") as f:
		probability = 1;
		outputFileName = "prob_" + testFile;
		templateToWrite = "C(%s) = %s\nC(%s) = %s\nParcial Probability_%d (%s|%s) = %s / %s = %.12g\n\n"
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

				frequencyBigram = getBigramFrequency("bigrams_s1.txt",bigram);
				print "frequency of bigram = "+ frequencyBigram;

				frequencyUnigram = getUnigramFrequency("unigrams_s1.txt",words[i]);
				print "frequency of unigram = "+ frequencyUnigram;

				portion = float(frequencyBigram) / float(frequencyUnigram);
				print "parcial probability = ", portion;

				bigramSpaced = bigram.replace('_', ',')

				lineToWrite = templateToWrite % (bigramSpaced, frequencyBigram,
				words[i],frequencyUnigram,iterator,words[i+1], words[i],
				frequencyBigram ,frequencyUnigram, portion);

				iterator = iterator + 1;
				insertLineOutputFile(outputFileName,lineToWrite);
				probability = probability * portion;
				print "";

			lineToWrite = finalTemplateToWrite % (testSentence[0], probability);
			insertLineOutputFile(outputFileName,lineToWrite);

	return probability;

def doOutputFile(inputFile):
	separator = "-" * 131
	outputFileName = "prob_" + inputFile;
	with open(outputFileName, "wt") as fout:
		fout.write(separator)
		fout.write("\n");fout.write("\n");
		fout.write("Made by Group 8:\n")
		fout.write("\n")

		fout.write(separator)
		fout.write("\n");fout.write("\n");
		fout.write("Computing the probability of the given test sentence from the file "+ inputFile +"\n")
		fout.write("Without Smoothing with the language model based on the Training\n")
		fout.write("file s1.txt\n")
		fout.write("\n")

		fout.write(separator)
		fout.write("\n");fout.write("\n");
		fout.write("The Probability Without Smoothing Formula was calculated this way:"+"\n")
		fout.write("\nProbability(Without Smoothing) = ∑_para_todos_os_bigramas (#ocorrências_do_bigrama) / (#ocorrências_da_primeira_palavra_do_bigrama)\n")
		fout.write("\n")
		fout.write(separator)
		fout.write("\n");fout.write("\n");

def insertLineOutputFile(outputFileName,line):

	with open(outputFileName, "a") as fout:
		fout.write(line)
		fout.write("\n")

def main():
	if len(sys.argv) != 1:
		separator = "-" * 131
		doOutputFile(sys.argv[1]);
		probability = getBigramProbability(sys.argv[1]);
		outputFileName = "prob_" + sys.argv[1];
		insertLineOutputFile(outputFileName,separator);
		print "final probability = ", probability;
	else:
		print "";
		print "[ERROR] How to run it: python prob.py <testFile.txt>";
		print "";

if __name__ == "__main__":
	main()
