function [  ] = postprocessorGRBL( G, options, outputName )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    [fileID,errmsg] = fopen(outputName,'w+');
    
    fprintf(fileID,'G90 ; use absolute coordinates \nG21 ; set units to millimeters \nG28 ; home all axes\n');
    
    G0(fileID,G.data(1,:),100);
    for i=1:size(G.data,1)
        G0(fileID,G.data(i,:));
    end
    
end

