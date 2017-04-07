%% Part 2
% Window length 20ms, overlap 50% (window interval 10ms)

clear

[x Fs] = audioread('birthdate_75268.wav');
M = Fs*0.020;
L = length(x);
b = zeros(1, M);
max_i = L/(M/2) - 1;
w = rectwin(M);
f0 = zeros(1, floor(max_i));
f0_aux = zeros(1, floor(max_i));

for i = 1:max_i
    b_start = (M/2)*(i-1)+1;
    b_end = (M/2)*(i-1)+M;
    b = x(b_start:b_end);
    y = b.*w;
    autocorr = xcorr(y);
    if(max(autocorr) < 2.5*10^(-3)) %% minimum energy for voiced/unvoiced
        continue;
    end
    autocorr = autocorr/max(autocorr);
    [pks ~] = findpeaks(autocorr);
    sortpks = sort(pks, 'descend');
    [j1 ~] = find(autocorr == sortpks(1));
    for j = 2:length(sortpks)
        [j2 ~] = find(autocorr == sortpks(j));
        if(abs(j1 - j2(1)) > Fs/400 && abs(j1 - j2(1)) < Fs/60 && sortpks(j) > 0.25) %% between 60Hz and 400Hz
            f0_aux(i) = (abs(j1 - j2(1))/Fs).^(-1);
            if(i > 1 && abs(f0_aux(i)-f0_aux(i-1)) < 20) %% pitch doesn't vary so fast
               f0(i) = f0_aux(i);
               break;
            end
        end
        
    end
end

avg_f0 = mean(f0(f0~=0));

fid = fopen('birthdate_75268.myf0', 'w');
fprintf(fid, '%f\n', f0);
fclose(fid);