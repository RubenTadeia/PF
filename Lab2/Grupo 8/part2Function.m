% Part 2 - autocorrelation method
clear, close, clc
disp('Function to compute the coefficients and the residual of linear prediction')
disp('Choose the parameters: ')
inputLength = input('Window length(ms): ');
inputInterval = input('Window interval(ms): ');
inputPredictionOrder = input('Prediction order: ');

inputFile = 'birthdate_75255_voiced.wav';
resOutputFile = 'birthdate_75255_res.wav';
synOutputFile = 'birthdate_75255_syn.wav';


[samples, sampleRate] = audioread(inputFile);
windowSize = sampleRate*inputInterval*0.001*0.5; %ms to seconds and 50% overlapping
windowLength = sampleRate*inputLength*0.001*0.5; %ms to seconds and 50% overlapping

% autocorrelation LPC analysis function
[ar, ~, ~] = lpcauto(samples, inputPredictionOrder, [windowSize windowLength]);

nWindows = length(ar(:,1)); % Number of frames
res = zeros(length(samples), 1); % Initialize with same size input audio file

[res(1:windowSize)] = filter(ar(1, :), 1, samples(1:windowSize));
for i = 1 : nWindows-1
    [res(i*windowSize:(i+1)*windowSize)] = filter(ar(i, :), 1, samples(i*windowSize:(i+1)*windowSize));
end
% Energy in the residual
energyRes = sum(abs(res).^2)
audiowrite('birthdate_75255_res.wav', res, sampleRate);
sound(res, sampleRate);

pause(3.5)

syn = zeros(length(res), 1);
[syn(1:windowSize)] = filter(1, ar(1, :), res(1:windowSize));
for i = 2 : nWindows-1
    [syn(i*windowSize:(i+1)*windowSize)] = filter(1, ar(i, :), res(i*windowSize:(i+1)*windowSize));
end
audiowrite('birthdate_75255_syn.wav', syn, sampleRate);
sound(syn, sampleRate);

