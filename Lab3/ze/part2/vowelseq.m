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
%vowelseq -> used to produce a synthesized vowel
%   vowelseq(vowel1, vowel2, f0, duration, intensity)
%
%   vowel1 is an integer value between 1 and the duration*100
%   vowel2 is an integer value between 1 and the duration*100
%   f0
%   duration
%   intensity

function synth = vowelseq(vowel1, vowel2, f0, duration, intensity) %, Fs)

    %Loading file from wavesurfer    
    filename = 'ola';
    
    %Garantee the mat file is present in same directory
    try
        file = strcat(filename, '.mat');
        formants = load(file, '-ascii');
    catch Exception
        if (strcmp(Exception.identifier,'MATLAB:load:couldNotReadFile'))
            msg = ['File ', filename, '.mat does not exist'];
            causeException = MException('MATLAB:FormantSynthesis:load',msg);
            Exception = addCause(Exception,causeException);
        end
            rethrow(Exception)
    end
    
    Fs = 8000;
    T0 = 1/f0;
    T0_samples = floor(Fs*T0);
    duration_samples_v1 = duration*Fs/2;
    duration_samples = duration*Fs;    
    
    pulse_train = zeros(1, duration_samples);
    for i = 1:T0_samples:duration_samples
        pulse_train(i) = intensity;
    end
    
    synth = pulse_train;
    for j = 1:4
        Ck = -0.95^2;
        Bk = 2*0.95*cos(2*pi*formants(vowel1, j)/Fs);
        Ak = 1 - Bk - Ck;
        synth(1:duration_samples_v1) = filter(Ak, [1 -Bk -Ck], synth(1:duration_samples_v1));
    end
    
    for j = 1:4
        Ck = -0.95^2;
        Bk = 2*0.95*cos(2*pi*formants(vowel2, j)/Fs);
        Ak = 1 - Bk - Ck;
        synth(duration_samples_v1:duration_samples) = filter(Ak, [1 -Bk -Ck], synth(duration_samples_v1:duration_samples));
    end
end