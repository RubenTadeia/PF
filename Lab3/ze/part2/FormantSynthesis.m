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
%FormantSynthesis -> used to produce a synthesized vowel
%   Formant0Snthesis(vowel, f0, duration, intensity)
%
%   vowel is an integer value between 1 and the duration*100
%   f0
%   duration
%   intensity

function FormantSynthesis(vowel, f0, duration, intensity)

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
    t0 = 1/f0;
    t0_samples = floor(Fs*t0); % Round towards minus infinity
    durationSamples = duration*Fs;
    poleMagnitude = 0.95;
    
    clock = zeros(1, durationSamples);
    for i = 1:t0_samples:durationSamples
        clock(i) = intensity;
    end

    synth = clock;
    for i = 1:4
        Ck = -poleMagnitude^2;
        Bk = 2*poleMagnitude*cos(2*pi*vowelFormants(vowel, i)/Fs);
        Ak = 1-Bk-Ck;
        synth = filter(Ak, [1 -Bk -Ck], synth);
    end
    audiowrite('formant_synthesis_FIXED.wav', synth, Fs);
    sound(synth, Fs);
    clear synth Fs;
end