function [] = plot3dGraph( G, opt)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    if ~isempty(G.data) || length(G.children)>0 
        hold on
        if nargin < 2 
            opt='';
        end
            %wenn G keine kinder hat oder diese keine daten haben
            if (~isfield(G,'children') || isempty([G.children(1).data]')) && ~isempty(G.data) 
                %G.children(1).data=G.data;
                %M=[G.children(1).data(1:2,1),G.children(1).data(1:2,2), h*ones(2,1)];
                axis equal                 
                plot3(G.data(:,1),G.data(:,2),G.data(:,3),opt);
            end
            if isfield(G,'children') && ~isempty([G.children(1).data]')
                for i=1:length(G.children)
                    M=[G.children(i).data(:,1),G.children(i).data(:,2), G.children(i).data(:,3)];
                    axis equal                 
                    plot3(M(:,1),M(:,2),M(:,3),opt);   
                end
            end
    end
end
