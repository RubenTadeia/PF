%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Instituto Superior Técnico          %
%                                              %
%             Speech Processing                %
%                                              %
%               Laboratório - 3                %
%   Part 2 - Formant synthesis using Matlab    %
%                                              %
%                  Grupo 8                     %
%                                              %
%      Student - José  Diogo    - Nº 75255     %
%      Student - Rúben Tadeia   - Nº 75268     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function synth = vowelseq(vowel1, vowel2, f0, duration, intensity, Fs)
    %Loading file from wavesurfer
    load -ASCII formants.mat
    
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