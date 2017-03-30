%clear all;
path(path, '../voiceBox/');

[x, Fs] = audioread('birthdate_75255.wav');
windowLength = Fs*0.02;
windowInterval = Fs*0.01;
nPolos = 16; %prediction order
skip = 0; % 50% overlapping?

[ar, ~, ~] = lpcauto(x, nPolos, [windowInterval windowLength skip]);
ar

[saida, Zf] = filter(num, den, entrada, Zi);

