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
%FormantSynthVariations -> used to produce a synthesized vowel
%   FormantSynthVariations(vowel, f0_min, f0_max, duration, intensity_min, intensity_max)
%
%   vowel is an integer value between 1 and the duration*100
%   f0_min
%   f0_max
%   duration
%   intensity_min
%   intensity_max

function synth = FormantSynthVariations(vowel, f0_min, f0_max, duration, intensity_min, intensity_max)%, Fs)



    %Loading file from wavesurfer   
    filename = 'O8';
    
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
    T0_min = 1/f0_max;
    T0_max = 1/f0_min;
    T0_min_samples = floor(Fs*T0_min);
    T0_max_samples = floor(Fs*T0_max);
    duration_samples = duration*Fs;
    poleMagnitude = 0.95;
    
    T0_slope = (T0_max_samples - T0_min_samples)/duration_samples;
    intensity_slope = (intensity_max - intensity_min)/duration_samples;
    
    pulse_train = zeros(1, duration_samples);
    i = 1;
    while i <= duration_samples
        pulse_train(i) = intensity_min + round(i*intensity_slope);
        i = i + T0_min_samples + round(i*T0_slope);
    end
    
    synth = pulse_train;
    for i = 1:4
        Ck = -poleMagnitude^2;
        Bk = 2*poleMagnitude*cos(2*pi*formants(vowel, i)/Fs);
        Ak = 1 - Bk - Ck;
        synth = filter(Ak, [1 -Bk -Ck], synth);
        audiowrite('formant_synthesis_var.wav',synth,Fs);
    end
end