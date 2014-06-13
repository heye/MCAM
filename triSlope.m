function [ erg ] = triSlope( normData )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    
    erg=abs(sum(normData*[0 0 1]'))/3;

end

