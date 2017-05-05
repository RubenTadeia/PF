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

function synth = FormantSynthesis(vowel, f0, duration, intensity)
    %Loading file from wavesurfer
    load a.mat
    Fs = 8000;
    T0 = 1/f0;
    T0_samples = floor(Fs*T0); % Round towards minus infinity
    duration_samples = duration*Fs;
    
    pulse_train = zeros(1, duration_samples);
    for i = 1:T0_samples:duration_samples
        pulse_train(i) = intensity;
    end

    synth = pulse_train;
    for i = 1:4
        Ck = -0.95^2;
        Bk = 2*0.95*cos(2*pi*formants(vowel, i)/Fs);
        Ak = 1 - Bk - Ck;
        synth = filter(Ak, [1 -Bk -Ck], synth);
    end
end