function [ G ] = removeChild( G, index)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

    v=ones(1,length(G.children));
    v(index)=0;
    v=logical(v);
    G.children=G.children(v);

end

