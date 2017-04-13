clear all;
clc

frameSize = 1600;
fftLen = 2048;

audioReader = dsp.AudioFileReader('birthdate_75268.wav');

fileInfo = info(audioReader);
Fs = fileInfo.SampleRate;

preEmphasisFilter = dsp.FIRFilter(...
        'Numerator', [1 -0.95]);