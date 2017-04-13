clear
[x, FS] = audioread('birthdate_75255_voiced.wav');
x

%autocorr(x),
%RHO = xcorr(x),
%plot(RHO),
%figure,
b = zeros(1, FS);
w = rectwin(FS);
y = b.*w;
ola = xcorr(x, x);
plot(ola)
[Y, I] = max(ola);
Y
figure
[acf, lags, bounds] = autocorr(x)
plot(acf)
[Y, I] = max(acf)

%%
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
%[y,Fs] = audioread(filename, samples);

[y,Fs] = audioread(filename);
%plot(fft(y))
plot(y)
%xcorr

sound(y,Fs),
