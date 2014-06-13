function [ heigths, minTriH, maxTriH ] = flexLayerH( tri, maxH, minH )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


    %% TODO: nur einen horizontalen z layer machen, wenn fl?che gro? genug ist
    
    maxTriH=triMaxZ(tri);
    minTriH=triMinZ(tri);

    if nargin < 3
        minH = 0.2;
    end
    if nargin < 2
        maxH = 1;
    end
    h=[];
    %% horizontale dreiecke finden, hier muss ein layer sein
    for i=1:length(tri.children)
        %triangle is horizontal
        if triSlope(tri.children(i).norm)==1
            %get z coordiante of triangle as a layer height
            h(end+1)=tri.children(i).data(3,3);
        end
    end
    
    %% delete multiple entries of same value
    h=sort(h)';
    htemp=h(1);
    for i=1:length(h)
        if htemp(end) < h(i);
            htemp(end+1) = h(i);
        end
    end
    htemp=htemp+10^-4*ones(size(htemp));
    
    
    %% flex height
    
%     cz(1)=minTriH;
%     j=2;
%     while cz(j-1) < maxTriH
%         cz(j)=cz(j-1)+max([minH, maxH*minSlopeAt(tri,cz(j-1))]);
%         j=j+1;
%     end
%     heigths=cz;
    %von oben nach unten durchlaufen bring bessere genauigkeit an
    %?bergangsstellen
    cz(1)=maxTriH;
    j=2;
    while cz(j-1) > minTriH
        cz(j)=cz(j-1)-max([minH, maxH*minSlopeAt(tri,cz(j-1))]);
        j=j+1;
    end
    heigths=[htemp, cz];
    heigths=sort(heigths,'descend');
    

end

