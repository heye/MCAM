function [ P ] = crossGE( G, E )
%CROSSGE this function evaluates if an edge E intersects with graph edges
%   P = CROSSGE( 'G', 'E' )
%       G is a graph, E is a 2X2 matrix 
%       E=[v1, v2]
%   P is a vector containing the intersection point between graph edges and
%   edge E
    P=[];
    
    for i=1:size(G.data,1)-1
        A=[G.data(i,1:2)', G.data(i+1,1:2)'];
        [erg,p]=crossEp(A, E);
        if erg==1
            P(end+1,:)=p';
        end
    end


end

