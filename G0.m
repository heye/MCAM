function [ output_args ] = G0(fileID, p, feedrate)
%G0 appends a G0 command at the given file ID
%   Detailed explanation goes here

    if nargin < 3
        fprintf(fileID,'G0 X%.3f Y%.3f Z%.3f\n',p(1),p(2),p(3));
    else
        fprintf(fileID,'G0 X%.3f Y%.3f Z%.3f F%.3f\n',p(1),p(2),p(3),feedrate);
    end
end

