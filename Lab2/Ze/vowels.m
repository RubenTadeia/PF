%load handel.mat
clc
filename = '@.wav';
%audiowrite(filename,y,Fs);
START = 0.025;
END = 0.636;
%0.636s --- 11280
%1s ------- x
%x = 11280/0.636

% Read only the first 2 seconds.
samples = [START*1.7736e+04 END*1.7736e+04];
clear y Fs
[y,Fs] = audioread(filename, samples);
plot(fft(y))
%xcorr

sound(y,Fs);