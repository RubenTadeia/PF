%% Parte 3

%The frequency resolution (in Hertz) of the FFT is:

window_size = 2048;
sampling_rate = 16000;

resolution = (sampling_rate)/(window_size);

fn = (theta2 - theta1 + 2*pi*n)/ (2*pi*(t2-t1));