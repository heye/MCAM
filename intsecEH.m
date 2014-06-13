function [ erg, alph ] = intsecEH(  P, h  )
%CROSSPE this function evaluates if a line in Y direction through point P
%intersects with line Q
%   h=0.1
%
%   Q=[0 0 0
%      1 1 1];
%
%   Q is a line from (0,0,0) to (1,1,1)
%   

    alph=(h-P(1,3))/(P(2,3)-P(1,3));

    %alph2=(h-P(2,3))/(P(1,3)-P(2,3)); 
    %if abs(alph+alph2-1) < 10^-2 && abs(alph+alph2-1) > 0
    %    alph+alph2-1 
    %end

    erg=P(1,:)+alph*(P(2,:)-P(1,:));
    
    %z=norm(erg - P(2,:)+alph2*(P(1,:)-P(2,:))) ;
    %if z < 10^-2 && z > 0
    %    z
    %end
end

