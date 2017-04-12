clear all;
close all;
clc

[y,fs] = audioread('../../Ze/birthdate_75255.wav');
d=fs*.02;
h=hamming(d);
%% Part 1.1 - Fundamental frequency of one vowel segment

% For a segment well defined (voiced = 1.15s)
ini= 1.15*fs;   %Initial time in samples
len=(2*d)/8;      %Pitch detect threshold
A = y(ini:ini+d-1); %Audiofile excerpt 
TOP=A.*h; 
x_C = xcorr(TOP,TOP);
[~,index] = max(x_C((d+len):(2*d-1)));
pitch = index+len
figure(1);
plot(x_C);