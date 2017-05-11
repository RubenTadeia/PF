% LIBSVMREAD - Read content of a LIBSVM data format file
%
%   [data, labels] = LIBSVMREAD(datafile)
%       data_file => input file of data in LIBSVM format (extension is ignored)
%       DATA => data matrix of n x attrs, with n the number of data samples and attrs the dimension of the samples (features)
%       labels => column vector containing the label class
%
%   NOTES:
%       I did this is 2 minutes, it may have bugs or not be general enough

% Authors:
%   Alberto Abad          <alberto.abad@tecnico.ulisboa.pt>
%
%  10 May 2017 -  Instituto Superior Técnico 

function [data, labels] = libsvmread(datafile, ndim) 


    if nargin < 1
        error('MATLAB:input','Not enough inputs!');
    elseif nargin < 2,
        warning('MATLAB:input','Not specified number of attributes');
        ndim = 0;
    end
   
    if isempty(datafile)
        error('MATLAB:input','File is empty!');
    end

    
    fr=fopen(datafile,'r');
        
    i=1;
    labels = [];
    data = [];
    while 1,
        
        line=fgetl(fr);
        
        if ~ischar(line), break, end
        
        [l, ~, ~, ni] = sscanf(line,'%d',1);
        labels = [ labels ;l];
        vec = sscanf(line(ni:end),'%d:%f ');
        
        if (ndim == 0),
                ndim=vec(end-1);
        end
        
        newvec=zeros(ndim,1);
        ind=vec(1:2:end);
        val=vec(2:2:end);
        
        newvec(ind) = val;
        
        data = [data; newvec'];
        if (length(val)~=ndim),
            warning('libsvmread:format', 'Unexpected number of attributes');
        end
        
        
        
        i=i+1;
        
    end
    
    fclose(fr);
        

end

