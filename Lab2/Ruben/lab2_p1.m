%% Lab 2 Part 1
% clear
% [x, Fs] = audioread('birthdate_75268.wav');
% numpoles = 16;
% wlen = Fs*0.020; % window length
% framesize = wlen*0.5; % window interval: overlap 50% between frames

%% Covariance
clear
clc;
[x, Fs] = audioread('birthdate_75268.wav');
numpoles = 16;
wlen = Fs*0.020; % window length
framesize = wlen*0.5; % window interval: overlap 50% between frames

t = zeros(length(x)/framesize-1, 2);
t(1, 1) = numpoles+1;
for i = 1:(length(x)/framesize - 1)
    t(i, 2) = t(i, 1) + framesize;
    t(i+1, 1) = t(i,2);
end

[ar, ~, ~] = lpccovar(x, numpoles, t);

max_i = length(ar(:,1));
res = zeros(length(x), 1);

% Compute the residual from coefficients
[res(1:framesize)] = filter(ar(1, :), 1, x(1:framesize));
for i = 2:max_i
    [res((i-1)*framesize:i*framesize)] = filter(ar(i, :), 1, x((i-1)*framesize:i*framesize));
end
audiowrite(res, Fs, 'birthdate_75268_res.wav');

% Resynthesize the signal
syn = zeros(length(res), 1);
[syn(1:framesize)] = filter(1, ar(1, :), res(1:framesize));
for i = 2:max_i
    [syn((i-1)*framesize:i*framesize)] = filter(1, ar(i, :), res((i-1)*framesize:i*framesize));
end
audiowrite(syn, Fs, 'birthdate_75268_syn.wav');

%[Y,FS,NBITS]=WAVREAD('vowels_75268.wav') 
