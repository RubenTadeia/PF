clear all;
close all;

[x, Fs] = audioread('../../Ze/birthdate_75255_voiced.wav');
f0_min = 60;
f0_max = 400;
win_length = 320;       %20ms window
win_interval = 160;     %10ms interval

N_samples = floor(size(x)/(win_length + win_interval));
window = hamming(win_length);
threshold = 0.32;

buffer = (320+Fs/400):(320+Fs/60);

k = 1;

for i=1:N_samples
    
    sign = x(k:(k + win_length - 1));
    new_sign = sign.*window;
    sign_corr = xcorr(new_sign);
    norm = sign_corr/max(sign_corr);
   
    for y=1:length(norm)
        if norm(y,1) < threshold
            norm(y,1) = 0;
        end
    end  
        
    [M,I] = max(norm(buffer));
    if(M == 0)
        F0(i) = 0;
    else
        F0_s = buffer(1) + I - win_length;
        F0(i) = Fs/F0_s;
       
    end
       k = k + win_length + win_interval;
end

% Valor final da frequência fundamental pelo método da autocorrelação
F0_final = mean(F0);