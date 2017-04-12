clear all;
close all;
clc

window_duration = 60e-3;
window_interval = 20e-3;
max_pitch = 350;
min_pitch = 70;
threshold = 0.4;

[input,Fs] = audioread('birthdate_75268.wav');

interval_samples = round(window_interval * Fs);
window_samples = round(window_duration * Fs);

hamming_window = hamming(window_samples);

k = 0;
for i=1:interval_samples:(size(input,1)-window_samples)
    k = k + 1;
    signal = input(i:(i+window_samples-1));
    signal_w_window = signal.*hamming_window;
    auto_correlation = xcorr(signal_w_window);
    auto_correlation = auto_correlation(window_samples:end)/auto_correlation(window_samples);
    min_sample = round(Fs/max_pitch);
    max_sample = round(Fs/min_pitch);
    [max_value, index] = max(auto_correlation(round(min_sample):round(max_sample)));
    index = index + round(min_sample);
    if max_value<threshold
        pitch(k) = 0;
    else
        pitch(k) = Fs/(index-1);
    end
    t(k) = k*round(interval_samples)/Fs;
end

fileID = fopen('birthdate_75268.myf0','w');
for i=1:size(pitch,2)
    fprintf(fileID,'%f\r\n', pitch(i));
end
fclose(fileID);

% calculate mean of pitch
pitch_mean = sum(pitch)/sum(pitch ~= 0);
