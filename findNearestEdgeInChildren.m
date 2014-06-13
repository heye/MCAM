function [ childIndex, minDist, reverse ] = findNearestEdgeInChildren( G, p )
%FINDNEARESTEDGEINCHILDREN find index, distance, and direction of the
%nearest edge in a graph
%   [ childIndex, minDist, reverse ] = FINDNEARESTEDGEINCHILDREN( G, p )
%   minDist is the minimal distance from point p to the next edge in G.
%   G is a graph, where each child represents one edge
%   reverse is 0 if the first point in children.data is the nearest 

    minDist=Inf;
    reverse=-1;
    
%     MDist=zeros(length(G.children),2);
%     
%     for i=1:length(G.children)
%         MDist(i,:)=[norm(G.children(i).data(1,:)-p),norm(G.children(i).data(2,:)-p)];
%     end
%     
%     [dist, index]=min(MDist);
%     childIndex=index(1);
%     
%     [distance, reverse]=min(dist);
%     reverse=reverse-1;
    
%minimal bessere performance
    for i=1:length(G.children)
        temp=norm(G.children(i).data(1,:)-p);
        if temp < minDist
            minDist=temp;
            childIndex=i;
            reverse=0;
        end
        temp=norm(G.children(i).data(2,:)-p);
        if temp < minDist
            minDist=temp;
            childIndex=i;
            reverse=1;
        end
    end
    
end

