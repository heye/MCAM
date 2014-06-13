function [ G ] = setInnerOuter( G )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    
    n=length(G.children);

    %% direction
    Z=-ones(n);
    
    %% for debugging
    %close all
    %plot3Graph(G.children(1),0);
    
    
    %% 
    for i=1:n
        for j=1:n
            Z(j,i)=contains(G.children(i).data(:,1:2), G.children(j).data(:,1:2));
            %numContains=numContains+contains(G.children(i).data(:,1:2), G.children(j).data(:,1:2));
        end
    end
    I=eye(n);
    for i=1:n     
        % sum(I(i,:)*Z ---- gibt die anzahl an graphen, die G(i) enthalten
        %ein graph mit ungerader anzahl 'contained by..' muss innen gefr?st
        %werden
        G.children(i).inner=mod(sum(I(i,:)*Z),2);
    end
    
    %Gout=G;
end

