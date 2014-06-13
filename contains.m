function [ erg ] = contains( G1, G2 )
%CONTAINS this functions checks if one graph contains another one
%   ERG = CONTAINS( 'G1', 'G2' ) 
%       ERG=1 => G1 contains G2
%       ERG=0 => G1 doesnt contain G2



    erg = 1;
    %pr?fen ob alle punkte von G2 in G1 liegen
    for i=1:size(G2,1)
        if containsGP(G1, G2(i,:)') == 0
            erg = 0;
%             fprintf('here1');
            return;
        end            
    end

    %pr?fen ob es keine geschnittenen kanten gibt
    for i=1:size(G1,1)-1
        for j=1:size(G2,1)-1
            %jede kante mit jeder testen
            if crossE(G1(i:i+1,:)', G2(j:j+1,:)') == 1
                erg = 0;
%                 fprintf('here2');
                return;
            end
        end
    end



end

