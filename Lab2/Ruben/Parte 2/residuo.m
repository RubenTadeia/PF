%% Needs "voicebox" toolbox
% 
% [x, res, syn, res_energy] = lpcanalysis(method, len, int, order)
%
method = 1: %autocorrelation method
%   method = 2: covariance method
%   len: window length in ms
%   int: window interval in ms
%   order: number of poles of the filter
function [x, res, syn, res_energy] = lpcanalysis(method, len, int, order)  
    [x, Fs] = audioread('birthdate_75268.wav');
    numpoles = order;
    wlen = Fs*len; % window length
    framesize = Fs*int; % window interval
    
    if(method == 1)
        [ar, ~, ~] = lpcauto(x, numpoles, [framesize wlen]);

        max_i = length(ar(:,1));
        res = zeros(length(x), 1);

        % Compute the residual from coefficients
        min = floor(0.5*framesize);
        max = min+framesize;
        Zi = zeros(1, numpoles);
        for i = 1:max_i
            [res(min:max), Zf] = filter(ar(i, :), 1, x(min:max), Zi);
            min = max;
            max = max + framesize;
            Zi = Zf;
        end
        res_energy = sum(abs(res).^2);
        audiowrite(res, Fs, 'birthdate_75268_res.wav');

        % Resynthesize the signal
        syn = zeros(length(res), 1);
        min = floor(0.5*framesize);
        max = min+framesize;
        Zi = zeros(1, numpoles);
        for i = 1:max_i
            [syn(min:max), Zf] = filter(1, ar(i, :), res(min:max), Zi);
            min = max;
            max = max + framesize;
            Zi = Zf;
        end
        audiowrite(syn, Fs, 'birthdate_75268_syn.wav');
    else if (method == 2)
            t = zeros(length(x)/framesize-1, 2);
            t(1, 1) = numpoles+1;
            for i = 1:(length(x)/framesize - 1)
                t(i, 2) = t(i, 1) + framesize;
                t(i+1, 1) = t(i,2);
            end

            [ar, ~, ~] = lpccovar(x, numpoles, t);
            
            max_i = length(ar(:,1));
            res = zeros(length(x), 1);
            
            % Compute the residual from coefficients
            min = floor(0.5*framesize);
            max = min+framesize;
            Zi = zeros(1, numpoles);
            for i = 1:max_i
                [res(min:max), Zf] = filter(ar(i, :), 1, x(min:max), Zi);
                min = max;
                max = max + framesize;
                Zi = Zf;
            end
            res_energy = sum(abs(res).^2);
            audiowrite(res, Fs, 'birthdate_75268_res.wav');
            
            % Resynthesize the signal
            syn = zeros(length(res), 1);
            min = floor(0.5*framesize);
            max = min+framesize;
            Zi = zeros(1, numpoles);
            for i = 1:max_i
                [syn(min:max), Zf] = filter(1, ar(i, :), res(min:max), Zi);
                min = max;
                max = max + framesize;
                Zi = Zf;
            end
            audiowrite(syn, Fs, 'birthdate_75268_syn.wav');
        end
    end
end