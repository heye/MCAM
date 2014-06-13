function [ Gout ] = mergeParallelPaths( G, ZTravel, options )
%MERGEPARALLELPATHS merges parallel toolpaths
%   [ Gout ] = mergeParallelPaths( G, ZTravel, options )
%   Gout is a graph with dimension Gout.data Nx4, where the last component
%   is 0 or one 1, which means the edge is a G0 or G1 command
    
    d=options.CutterDia;
    
    %plot3dGraph(G);
    
    Gout=graph([]);
    %cut first edge
    Gout.data=[G.children(1).data, [1;1]];
    while ~isempty(G.children)
        [nextEdgeIndex, distance, reverse]=findNearestEdgeInChildren(G,Gout.data(end,1:3));
        
        %abstand zwischen edges zu gro?-> tool anheben und zur edge fahren
        if(distance > d)
            %lift cutter
            Gout.data(end+1,:)=[Gout.data(end,1:2),ZTravel, 0];
            %zum anfang oder ende der edge fahren
            if ~reverse
                Gout.data(end+1,:)=[G.children(nextEdgeIndex).data(1,1:2),ZTravel, 0];
            else
                Gout.data(end+1,:)=[G.children(nextEdgeIndex).data(2,1:2),ZTravel, 0];
            end
        end       
        
        if ~reverse
            Gout.data(end+1,:)=[G.children(nextEdgeIndex).data(1,:), 1];
            Gout.data(end+1,:)=[G.children(nextEdgeIndex).data(2,:), 1];
        else
            Gout.data(end+1,:)=[G.children(nextEdgeIndex).data(2,:), 1];
            Gout.data(end+1,:)=[G.children(nextEdgeIndex).data(1,:), 1];
        end
        
        G=removeChild(G,nextEdgeIndex);
    end
    %lift tool at end of layer
    Gout.data(end+1,:)=[Gout.data(end,1:2),ZTravel,0];
    %plot3dGraph(Gout);
    
end

