function [ maxZ ] = triMaxZ(tri)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    maxZ=max(tri.children(1).data(:,3));
    for i=1:length(tri.children)    
        z=max(tri.children(i).data(:,3));
        if z>maxZ
            maxZ=z;
        end
    end
end

