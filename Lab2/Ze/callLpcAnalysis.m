clear, close, clc

% [x, res, syn, res_energy] = lpcanalysis(1, 3.4, 0.020, 16)

% [x, res, syn, res_energy] = lpcanalysis(2, 3.4, 0.020, 16)

[data FS] = audioread('birthdate_75255_voiced.wav');

% fs = FS*20*0.001; %20ms
% fr = FS*20*0.001; %20ms
fs = 20
fr = 20
L = 16
% L = FS*3.0; % file duration
preemp = 0.9378; % default
[aCoeff,res_id,pitch,G,parcor,stream] = proclpc(data,FS,L,fr,fs,preemp);
audiowrite('birthdate_75255_res.wav', res_id, FS);
