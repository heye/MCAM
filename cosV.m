function [ alph ] = cosV( v1,v2 )
%cosV calculates the cos of the angle between two vectors
%   ALPH = COSV( 'v1', 'v2' )
%   
%   size(vi) = 3 1

    alph=v1'*v2/(norm(v1)*norm(v2));
    
end

