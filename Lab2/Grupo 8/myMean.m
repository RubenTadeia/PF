function Mean = myMean(file)
    fin = fopen(file, 'r');
    size = 0;
    numberZeros = 0;
    Mean = 0;
    while ~feof(fin)
        fileLine = fgets(fin);
        if (fileLine(1)=='0')
             numberZeros = numberZeros + 1;
        end
        if (fileLine(1)~=0)
            size = size + 1;
            Mean = Mean + fileLine(1);
        end
    end
    numberZeros
    size = size - numberZeros;
    Mean = Mean/size;
    fclose(fin);
end

