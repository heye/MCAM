function [ minZ ] = triMinZ(tri)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    minZ=min(tri.children(1).data(:,3));
    for i=1:length(tri.children)    
        z=min(tri.children(i).data(:,3));
        if z<minZ
            minZ=z;
        end
    end
end

