function [ options ] = daeset( varargin )
%daeset generates struct with parmeters for dae2tri
%   ex:
%   options=daeset('plot','display');
%   dae2tri('Motorblock.dae',options);
%

% Print out possible values of properties.
if (nargin == 0) && (nargout == 0)
    fprintf('   display: output information during conversion\n');
    fprintf('      plot: show a plot at the end of conversion\n');
else

    options=struct('display', '');
    options.plot='';

    for i=1:nargin
        if strcmp(varargin(i), 'display')
            options.display='true';
        end
        if strcmp(varargin(i), 'plot')
            options.plot='true';
        end
    end

end
