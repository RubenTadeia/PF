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
%   FormantSynthesis(vowel, f0, duration, intensity)
%
%   vowel is an integer value between 1 and the duration*100
%   f0 is the fundamental frequency
%   duration of the output file in seconds
%   intensity is the saturation of the output file

function FormantSynthesis(vowel, f0, duration, intensity)
    
    %Loading file obtained from wavesurfer    
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
    
    %Declarations and convertions of variables
    Fs = 8000;
    t0 = 1/f0;
    t0Samples = floor(t0*Fs); % Round towards minus infinity
    durationSamples = duration*Fs;
    poleMagnitude = 0.95;  
    clock = zeros(1, durationSamples);
    
    %Initialize the clock with given intensity
    for i = 1:t0Samples:durationSamples
        clock(i) = intensity;
    end

    %Applying transfer function of a ressonator
    synth = clock;
    for i = 1:4
        Ck = -poleMagnitude^2;
        Bk = 2*poleMagnitude*cos(2*pi*vowelFormants(vowel, i)/Fs);
        Ak = 1-Bk-Ck;
        synth = filter(Ak, [1 -Bk -Ck], synth);
    end
    
    %Loop to convert positive values to 1 and negative to -1
    %Fix audiowrite warnings
    for index=1:length(synth)
        if synth(1, index)<0
            synth(1, index)=-1;
        elseif synth(1, index)>0
            synth(1, index)=1;
        end
    end
    
    %Saves the synthesized audio file
    audiowrite('formant_synthesis_fixed.wav', synth, Fs);

    %Play the output synthesized audio file
    disp('Put your headphones!');
    disp('Sound starting in:');
    for s=3:-1:1
        disp(s);
        pause(1);
    end
    sound(synth, Fs);
    
end