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
%SynthesizeSeq-> used to produce a synthesized vowel
%   SynthesizeSeq(firstVowel, secondVowel, f0, duration, intensity)
%
%   firstVowel is an integer value between 1 and the duration*100
%   secondVowel is an integer value between 1 and the duration*100
%   f0
%   duration
%   intensityintensitintensityy

function SynthesizeSeq(firstVowel, secondVowel, f0, duration, intensity)

    %Loading file from wavesurfer    
    filename = 'ola';
    
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
    t0Samples = floor(Fs*t0);
    durationSamples_v1 = duration*Fs/2;
    durationSamples = duration*Fs;    
    
    clock = zeros(1, durationSamples);
    for i = 1:t0Samples:durationSamples
        clock(i) = intensity;
    end
    
    synth = clock;
    for j = 1:4
        Ck = -0.95^2;
        Bk = 2*0.95*cos(2*pi*vowelFormants(firstVowel, j)/Fs);
        Ak = 1 - Bk - Ck;
        synth(1:durationSamples_v1) = filter(Ak, [1 -Bk -Ck], synth(1:durationSamples_v1));
    end
    
    for j = 1:4
        Ck = -0.95^2;
        Bk = 2*0.95*cos(2*pi*vowelFormants(secondVowel, j)/Fs);
        Ak = 1 - Bk - Ck;
        synth(durationSamples_v1:durationSamples) = filter(Ak, [1 -Bk -Ck], synth(durationSamples_v1:durationSamples));
    end
end