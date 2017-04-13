%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Instituto Superior Técnico          %
%                                              %
%             Speech Processing                %
%                                              %
%               Laboratório - 2                %
%                                              %
%                  Grupo 8                     %
%                                              %
%      Student - José  Diogo    - Nº 75255     %
%      Student - Rúben Tadeia   - Nº 75268     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Part 1 - Fundamental Frequency Estimation

clear all;
close all;
clc

%This parameters are hardcoded and they are not the same for different students
window_length = 0.06;
interval_size = 0.02; %The interval of the window - 20ms

%For Student 75255
max_pitch = 130; %Max value for f0
min_pitch = 90;  %Lowest value for f0
%For Student 75268
% max_pitch = 350; %Max value for f0
% min_pitch = 70;  %Lowest value for f0

threshold = 0.30; %This is the value we choose in order for f0 to have
%Close Values

[input,sampling_frequency] = audioread('birthdate_75255.wav');
% [input,sampling_frequency] = audioread('birthdate_75268.wav');
% [input,sampling_frequency] = audioread('@_75255.wav');
% [input,sampling_frequency] = audioread('@_75268.wav');


interval_samples = round(interval_size * sampling_frequency);
samples = round(window_length * sampling_frequency);

%Now that we have the number of samples in the window
%We will use a hamming window
hamming_window = hamming(samples);

iteration = 0;
for i=1:interval_samples:(size(input,1)-samples)
    %Feeding the loop and incrementing iteration
    iteration = iteration + 1;
    
    %Auto Correlation with new signals
    signal_correlation = input(i:(i+samples-1));
    signal_w_window = signal_correlation.*hamming_window;
    auto_correlation = xcorr(signal_w_window);
    %
    auto_correlation = auto_correlation(samples:end)/auto_correlation(samples);

    
    %The minimum value of the sample is obtained with the maximum value of the pitch
    min_sample = round(sampling_frequency/max_pitch);
    
    %The maximum value of the sample is obtained with the minimum value of the pitch
    max_sample = round(sampling_frequency/min_pitch);


    %With the previous result we can  find the maximum value of the correlation and then
    %Compare him with our predefined value for threshold
    [max_value, index] = max(auto_correlation(round(min_sample):round(max_sample)));
    index = index + round(min_sample);
    

    if max_value<threshold % The value does not meet the threshold and is ignored
        pitch(iteration) = 0;
    else % The value does meet the threshold and is higher or equal
        pitch(iteration) = sampling_frequency/(index-1);
    end
    time(iteration) = iteration*round(interval_samples)/sampling_frequency;
end

%Creating an exit to write our results
outputFile = fopen('birthdate_75255.myf0','w');
% outputFile = fopen('birthdate_75268.myf0','w');
% outputFile = fopen('@_75255.myf0','w');
% outputFile = fopen('@_75268.myf0','w');


for i=1:size(pitch,2)
    %Write new line in myf0 file!
    fprintf(outputFile,'%f\r\n', pitch(i));
end
fclose(outputFile);

% calculate mean of pitch
pitch_mean = sum(pitch)/sum(pitch ~= 0)