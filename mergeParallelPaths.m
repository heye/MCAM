function [ Gout ] = mergeParallelEdges( G, ZTravel, d )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    
    
    %plot3dGraph(G);
    
    Gout=graph([]);
    Gout.data=G.children(1).data;
    while ~isempty(G.children)
        [nextEdgeIndex, distance, reverse]=findNearestEdgeInChildren(G,Gout.data(end,:));
        
        %abstand zwischen edges zu gro?-> tool anheben und zur edge fahren
        if(distance > d)
            Gout.data(end+1,:)=[Gout.data(end,1:2),ZTravel];
            %zum anfang oder ende der edge fahren
            if ~reverse
                Gout.data(end+1,:)=[G.children(nextEdgeIndex).data(1,1:2),ZTravel];
            else
                Gout.data(end+1,:)=[G.children(nextEdgeIndex).data(2,1:2),ZTravel];
            end
        end       
        
        if ~reverse
            Gout.data(end+1,:)=G.children(nextEdgeIndex).data(1,:);
            Gout.data(end+1,:)=G.children(nextEdgeIndex).data(2,:);
        else
            Gout.data(end+1,:)=G.children(nextEdgeIndex).data(2,:);
            Gout.data(end+1,:)=G.children(nextEdgeIndex).data(1,:);
        end
        
        G=removeChild(G,nextEdgeIndex);
    end
    %am ende des layers das tool anheben
    Gout.data(end+1,:)=[Gout.data(end,1:2),ZTravel];
    %plot3dGraph(Gout);
    
end

