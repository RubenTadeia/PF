function Mean = myMean(file)
    fin = fopen(file, 'r');
    Size = 0;
    Mean = 0;
    while ~feof(fin)
        Line = fgets(fin);
        Splitted = strsplit(Line,' ');
        if (str2num(cell2mat(Splitted(1))) ~= 0)
            Size = Size + 1;
            Mean = Mean + str2num(cell2mat(Splitted(1)));
        end
    end
    Mean = Mean/Size
    fclose(fin);
end

