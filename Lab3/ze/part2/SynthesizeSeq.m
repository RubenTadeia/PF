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
%   firstVowel is an integer value between 1 and 9 (see values below)
%   secondVowel is an integer value between 1 and 9 (see values below)
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

function SynthesizeSeq(firstVowel, secondVowel, f0, duration, intensity)

    %Loading formants file obtained from wavesurfer    
    filename = 'vowelFormants';
    
    %If value of vowel is a char, map to index file values
    firstVowel = convertChar(firstVowel);
    secondVowel = convertChar(secondVowel);
    
    %Check arguments range
    checkInputVowel(firstVowel);
    checkInputVowel(secondVowel);
    checkInput(f0, duration);
    
    %Garantee the mat file is present in same directory
    vowelFormants = getFormants(filename);
    
    %Declarations and convertions of variables
    Fs = 8000;
    t0 = 1/f0;
    t0Samples = floor(Fs*t0);
    %duration for single vowel
    durationSamplesSingle = duration*Fs/2;
    %duration of full audio file
    durationSamples = duration*Fs;
    clock = zeros(1, durationSamples);
    poleMagnitude = 0.95;
    
    %Initialize the pulse train
    for i = 1:t0Samples:durationSamples
        clock(i) = intensity;
    end
    
    %Applying transfer function of a ressonator for first vowel
    synth = clock;
    for j = 1:4
        Ck = -poleMagnitude^2;
        Bk = 2*poleMagnitude*cos(2*pi*vowelFormants(firstVowel, j)/Fs);
        Ak = 1 - Bk - Ck;
        synth(1:durationSamplesSingle) = filter(Ak, [1 -Bk -Ck], synth(1:durationSamplesSingle));
    end
    
    %Applying transfer function of a ressonator for second vowel
    for j = 1:4
        Ck = -poleMagnitude^2;
        Bk = 2*poleMagnitude*cos(2*pi*vowelFormants(secondVowel, j)/Fs);
        Ak = 1 - Bk - Ck;
        synth(durationSamplesSingle:durationSamples) = filter(Ak, [1 -Bk -Ck], synth(durationSamplesSingle:durationSamples));
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
    audiowrite('formant_synthesis_seq.wav', synth, Fs);
    
    %Play the output synthesized audio file
    headPhonesPrint();
    sound(synth, Fs);
end