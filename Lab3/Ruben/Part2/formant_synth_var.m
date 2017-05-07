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

function synth = formant_synth_var(vowel, f0_min, f0_max, duration, intensity_min, intensity_max, Fs)
    %Loading file from wavesurfer
    load -ASCII formants.mat
    
    T0_min = 1/f0_max;
    T0_max = 1/f0_min;
    T0_min_samples = floor(Fs*T0_min);
    T0_max_samples = floor(Fs*T0_max);
    duration_samples = duration*Fs;
    
    T0_slope = (T0_max_samples - T0_min_samples)/duration_samples;
    intensity_slope = (intensity_max - intensity_min)/duration_samples;
    
    pulse_train = zeros(1, duration_samples);
    i = 1;
    while i <= duration_samples;
        pulse_train(i) = intensity_min + round(i*intensity_slope);
        i = i + T0_min_samples + round(i*T0_slope);
    end
    
    synth = pulse_train;
    for i = 1:4
        Ck = -0.95^2;
        Bk = 2*0.95*cos(2*pi*formants(vowel, i)/Fs);
        Ak = 1 - Bk - Ck;
        synth = filter(Ak, [1 -Bk -Ck], synth);
    end
end