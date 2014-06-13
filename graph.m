function [ gr ] = graph( data )
%GRAPH creates a graph struct, with the given data as nodes
%   gr = GRAPH( 'DATA' ) generates a graph with nodes from DATA
%
%   gr = GRAPH([]) generates an empty graph
%
%   graphs can be visualised with plot3dGraph
    gr=struct();
    gr.data=data;
    gr.dir=0; %0=left  1=right
    gr.zLevel=0;
    gr.children=struct('data',[]);
end

