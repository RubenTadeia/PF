clear
disp('Insert student number:');
number = input('Number(5 digits): ');

init = strcat('birthdate_', int2str(number));
f0FileName = strcat(init, '.f0');
myf0FileName = strcat(init, '.myf0');

fout = fopen('f0_results.txt', 'w');

waveMean = myMean(f0FileName);
fprintf(fout, 'Average F0 (wavesurfer): %f Hz\n', waveMean);

autoMean = myMean(myf0FileName);
fprintf(fout, 'Average F0 (autocorr.): %f Hz\n', autoMean);

fclose(fout);
