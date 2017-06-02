#!/bin/bash
#
# Processamento da Fala 2015/2016
# Grupo 12
#
# Computes the list of unigrams and bigrams and saves them in the files s1.un and s.bi, respectively

tr ' ' '\n' <s1.txt >s1.un

echo "\nVocabulary size:"
sort s1.un | uniq | wc -l

echo "\nNumber of unigrams:"
wc -l s1.un

sort s1.un | uniq -c | sort -r >s1.unfr
echo "\n10 most frequent unigrams:"
sort s1.un | uniq -c | sort -r -n -k 1 | head -10

awk '{if(NR > 1) print ant " " $1; ant = $1}' s1.un | grep -v '</s> <s>' >s1.bi

echo "\nNumber of bigrams:"
wc -l s1.bi

sort s1.bi | uniq -c | sort -r >s1.bifr
echo "\n10 most frequent bigrams:"
sort s1.bi | uniq -c | sort -r -n -k 1 | head -10

