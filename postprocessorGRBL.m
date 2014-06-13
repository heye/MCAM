function [  ] = postprocessorGRBL( G, options, outputName )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    [fileID,errmsg] = fopen(outputName,'w+');
    
    fprintf(fileID,'G90 ; use absolute coordinates \nG21 ; set units to millimeters \nG28 ; home all axes\n');
    
    currentG1Feed=0;
    currentG0Feed=0;
    G1Len=0;
    G0Len=0;
    for i=1:size(G.data,1) 
        if G.data(i,4)
            G1Len=G1Len+norm(G.data(i,1:3));
            if currentG1Feed ~= options.FeedXY;
                G1(fileID,G.data(i,1:3),options.FeedXY);
                currentG1Feed=options.FeedXY;
            else
                G1(fileID,G.data(i,1:3));
            end
        else    
            G0Len=G0Len+norm(G.data(i,1:3));    
            if currentG0Feed ~= options.FeedXYTravel;       
                G0(fileID,G.data(i,:),options.FeedXYTravel);
                currentG0Feed=options.FeedXYTravel;
            else
                G0(fileID,G.data(i,:));
            end
        end
    end
    
    G1Len
    G0Len
    ETA=G1Len/options.FeedXY+G0Len/options.FeedXYTravel
end

