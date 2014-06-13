function [ erg ] = containsGP( G, P )
%CONTAINSGP test if a graph contains a point 
%   ERG = CONTAINSGP( 'G' ,'P' )
%   G is a N x 3 matrix representing the x,y,z values of N graph nodes with 
%   constant z value
%       ERG=1 => G contains P
%       ERG=0 => G doesn't contain P
erg = 0;
    %initialisierung, damit werte angeh?ngt werden k?nnen
    Q=0;
    for i=1:size(G,1)-1
        [pc, alpha]=crossPE(P, G(i:i+1,:)');
        %punkt liegt auf der linie
        %startpunkt geh?rt nicht dazu, da ansonsten diese punkte doppelt
        %vorkommen w?rden, da startpunkte der einen edge endpunkte der
        %vorherigen sind
        if 0 < alpha && alpha <= 1
            Q(length(Q)+1) = pc(2);
        end
    end
    
    %abbrechen wenn keine punkte gefunden wurden
    if length(Q) < 2
        erg = 0;
        %fprintf('gbhere1');
        return;
    end
    
    %aufsteigend sortieren und letzten wert abschneiden
    Q=sort(Q(2:length(Q)));
    
    %plot(P(2)*ones(size(Q)),Q, 'kx')
    
    
    %doppelt vorkommende werte abschneiden
    %TODO: herausfinden ob diese ?berhaupt noch vorkommen k?nnen
%     Qn=Q(1);
%     for i=2:length(Q)
%         if Qn(end)~=Q(i)
%             Qn(end+1)=Q(i);
%         end
%     end
%     Q=Qn;

    for i=1:length(Q)-1
        
        erg=0;
        if Q(i) < P(2) && Q(i+1) > P(2) && mod(i, 2) == 1
            erg = 1;
            return;
        end
%                 i
%                 Q'
%                 P(2)
%                 fprintf('gbhere2');
%                 erg = 0;
%                 return;
%         end
    end
    
end

