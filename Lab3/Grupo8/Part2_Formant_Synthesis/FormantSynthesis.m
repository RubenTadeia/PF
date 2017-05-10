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
%   vowel is an integer value between 1 and 9 (see values below)
%   f0 is the fundamental frequency
%   duration of the output file in seconds
%   intensity is the saturation of the output file
%
%   a - 1
%   E - 2
%   i - 3
%   O - 4
%   u - 5
%   6 - 6
%   e - 7
%   o - 8
%   @ - 9

function FormantSynthesis(vowel, f0, duration, intensity)
    
    %Loading formants file obtained from wavesurfer    
    filename = 'vowelFormants';
    
    %If value of vowel is a char, map to index file values
    vowel = convertChar(vowel);
    
    %Check arguments range
    checkInputVowel(vowel);
    checkInput(f0, duration);
        
    %Garantee the mat file is present in same directory
    vowelFormants = getFormants(filename);
    
    %Declarations and convertions of variables
    Fs = 8000;
    t0 = 1/f0;
    t0Samples = floor(t0*Fs); % Round towards minus infinity
    durationSamples = duration*Fs;
    poleMagnitude = 0.95;  
    clock = zeros(1, durationSamples);
    
    %Initialize the pulse train with given intensity
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
    headPhonesPrint();
    sound(synth, Fs);
end