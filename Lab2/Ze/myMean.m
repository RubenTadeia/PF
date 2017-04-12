function Mean = myMean(file)
    fin = fopen(file, 'r');
    size = 0;
    Mean = 0;
    while ~feof(fin)
        line = fgets(fin);
        if (line(1)~=0)
            size = size + 1;
            Mean = Mean + line(1);
        end
    end
    Mean = Mean/size;
    fclose(fin);
end

