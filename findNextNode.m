function [ G, v ] = findNextNode( G, P, tol )
%FINDNEXTNODE finds an edge
%   [ E, v ] = FINDNEXTNODE( 'G', 'P', 'tol' )
%   G is a Nx3 matrix representing pairwise the nodes of edges, P is the
%   startpoint of an edge. 
%   v is the corresponding endpoint with tolerance tol and E the reduced
%   matrix G without the found edge


%     E=[];
    v=[];
    %positionen der knoten von aufeinanderfolgenden kanten werden nicht
    %exakt berechnet, daher ist eine toleranz beim abstand der knoten n?tig
    % sqrt(eps)  gibt eine genauigkeit von ca. 10^-8 mm... sollte reichen
    
    if nargin < 3
        tol=sqrt(eps);
    end
    
    I=true(size(G,1),1);
    for i=1:size(G,1)
        if sum(abs((G(i,:)-P)))<tol && mod(i,2)==1            
            v = G(i+1,:);
            I(i:i+1)=[0;0];
            G=G(I,:);
            return;
        end
        if sum(abs((G(i,:)-P)))<tol && mod(i,2)==0            
            v = G(i-1,:);
            I(i-1:i)=[0;0];
            G=G(I,:);
            return;
        end
    end 
    G=[];
    
%     for i=1:size(G,1)
%         if sum(abs((G(i,:)-P)))<tol && mod(i,2)==1            
%             v = G(i+1,:);
%             E(1:i-1,1:3) = G(1:i-1,1:3);
%             E(i:size(G,1)-2,1:3) = G(i+2:size(G,1),1:3);
%             return;
%         end
%         if sum(abs((G(i,:)-P)))<tol && mod(i,2)==0            
%             v = G(i-1,:);
%             if i-2 > 0
%                 E(1:i-2,1:3) = G(1:i-2,1:3);
%                 E(i-1:size(G,1)-2,1:3) = G(i+1:size(G,1),1:3);
%             else
%                 E(1:size(G,1)-2,1:3) = G(i+1:size(G,1),1:3);
%             end
%             return;
%         end
%     end
end

