%%
clear all; close all;
f = [894.37 487.83 261.22 577.60 310.20 637.77 461.78 456.89 446.21; 1445.51 2283.46 2519.87 999.40 788.42 1591.57 1959.82 851.67 1801.59];
figure;
axis([250 900 750 2600]);
grid on, hold on,
plot(f(1,:),f(2,:), 'r.', 'markersize', 15);
title('Vowels Triangle');
xlabel('F1');
ylabel('F2');
%%

%894.37 1445.51
%487.83 2283.46
%261.22 2519.87
%577.60 999.40
%310.20 788.42
%637.77 1591.57
%461.78 1959.82
%456.89 851.67
%446.21 1801.59

