function [ erg ] = minSlopeAt( tri, height )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    
    %% reduce trianges to relevant subset
    numTri=1;
    %triSubset=[];
    j=1;
    for i=1:length(tri.children)    
        triZmax=max(tri.children(i).data(:,3));
        triZmin=min(tri.children(i).data(:,3));
        if triZmin < height && height < triZmax
            triSubset.children(j)=tri.children(i);
            j=j+1;
        end
    end
    %no subset -> return
    if ~any(strcmp(who,'triSubset'))
        %warning('empty triangle subset at %dmm!', height);
        erg=0;
        return;
    end
    
    erg=1;
    %% find min slope in subset
    slope=zeros(1,length(triSubset.children));
    for i=1:length(triSubset.children)
        slope=1-triSlope(triSubset.children(i).norm); 
        if slope ~= 0 && slope < erg
            erg=slope;
        end
    end   
    %erg=min(slope);
end

