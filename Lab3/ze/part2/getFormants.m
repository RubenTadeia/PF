function vowelFormants = getFormants(filename)
    try
        file = strcat(filename, '.mat');
        vowelFormants = load(file, '-ascii');
    catch Exception
        if (strcmp(Exception.identifier,'MATLAB:load:couldNotReadFile'))
            msg = ['File ', filename, '.mat does not exist'];
            causeException = MException('MATLAB:FormantSynthVariations:load',msg);
            Exception = addCause(Exception,causeException);
        end
            rethrow(Exception)
    end
end