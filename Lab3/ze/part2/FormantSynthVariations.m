%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Instituto Superior Tecnico          %
%                                              %
%             Speech Processing                %
%                                              %
%               Laboratorio - 3                %
%   Part 2 - Formant synthesis using Matlab    %
%                                              %
%                  Group 8                     %
%                                              %
%      Student - Jose  Oliveira - Nr 75255     %
%      Student - Ruben Tadeia   - Nr 75268     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%vowelFormantsynthVariations -> used to produce a synthesized vowel
%   vowelFormantsynthVariations(vowel, f0Min, f0Max, duration, intensityMin, intensityMax)
%
%   vowel is an integer value between 1 and the duration*100
%   f0Min
%   f0Max
%   duration
%   intensityMin
%   intensityMax

function vowelFormantsynthVariations(vowel, f0Min, f0Max, duration, intensityMin, intensityMax)



    %Loading file from wavesurfer   
    filename = 'O8';
    
    %Garantee the mat file is present in same directory
    try
        file = strcat(filename, '.mat');
        vowelFormants = load(file, '-ascii');
    catch Exception
        if (strcmp(Exception.identifier,'MATLAB:load:couldNotReadFile'))
            msg = ['File ', filename, '.mat does not exist'];
            causeException = MException('MATLAB:vowelFormantsynthesis:load',msg);
            Exception = addCause(Exception,causeException);
        end
            rethrow(Exception)
    end
    
    Fs = 8000;
    t0Min = 1/f0Max;
    t0Max = 1/f0Min;
    t0MinSamples = floor(Fs*t0Min);
    t0MaxSamples = floor(Fs*t0Max);
    durationSamples = duration*Fs;
    poleMagnitude = 0.95;
    
    t0Slope = (t0MaxSamples - t0MinSamples)/durationSamples;
    intensity_slope = (intensityMax - intensityMin)/durationSamples;
    
    clock = zeros(1, durationSamples);
    i = 1;
    while i <= durationSamples
        clock(i) = intensityMin + round(i*intensity_slope);
        i = i + t0MinSamples + round(i*t0Slope);
    end
    
    synth = clock;
    for i = 1:4
        Ck = -poleMagnitude^2;
        Bk = 2*poleMagnitude*cos(2*pi*vowelFormants(vowel, i)/Fs);
        Ak = 1 - Bk - Ck;
        synth = filter(Ak, [1 -Bk -Ck], synth);
    end
    audiowrite('formant_synthesis_var.wav',synth,Fs);
    sound(synth, Fs);
    clear synth Fs;
end