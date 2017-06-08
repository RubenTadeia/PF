#!/usr/bin/python
# coding: iso-8859-1

# Processamento da Fala 2016/2017
# Grupo 8
#

#Import for sorting
import operator

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
			unigram=str(k[0]) + " " + str(k[1])
			if n < numberUnigramsToPrint:
				print unigram
				frequentUnigrams.append(unigram)
				n += 1
			fout.write(unigram + "\n")

	return frequentUnigrams


def doBigrams(fNameIn, fNameOut):

	#Dictionary of bigrams
	bigrams={}

	# Open Training File
	with open(fNameIn, "rt") as fin:

		for line in fin:
			words = line.split()
			for i in range(0, len(words)-1):
				bigram = words[i] + "_" + words[i+1]

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


def doVocabularySize(fname):
	with open(fname, "rt") as f:
		for i, l in enumerate(f):
			pass
	return i + 1

def doOutputFile(frequentUnigrams, frequentBigrams, numberUnigrams, numberBigrams, vocabSize):

	with open("ngrams_s1.txt", "wt") as fout:
		fout.write("Made by Group 8:\n")

		fout.write("\n")
		fout.write("Vocabulary size:\n")
		fout.write(str(vocabSize)+"\n")

		fout.write("\n")
		fout.write("Number of unigrams\n")
		fout.write(str(numberUnigrams)+"\n")

		fout.write("\n")
		fout.write("10 most frequent unigrams\n")
		for i in frequentUnigrams:
			fout.write(i+"\n")

		fout.write("\n")
		fout.write("Number of bigrams\n")
		fout.write(str(numberBigrams)+"\n")

		fout.write("\n")
		fout.write("10 most frequent bigrams\n")
		for i in frequentBigrams:
			fout.write(i+"\n")

def numberOfNgrams(fname):
	with open(fname, "rt") as f:
		count = 0
		for line in f:
			value = line.split()
			count += int(value[1])
	return count


def main():
	frequentUnigrams = doUnigrams("s1.txt", "unigrams_s1.txt")
	frequentBigrams = doBigrams("s1.txt", "bigrams_s1.txt")

	numberUnigrams = numberOfNgrams("unigrams_s1.txt")
	numberBigrams = numberOfNgrams("bigrams_s1.txt")
	vocabSize = doVocabularySize("unigrams_s1.txt")

	doOutputFile(frequentUnigrams, frequentBigrams, numberUnigrams, numberBigrams, vocabSize)


if __name__ == "__main__":
	main()
