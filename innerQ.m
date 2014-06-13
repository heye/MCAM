function [ Q ] = innerQ( Pset, d )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    e3=[0 0 1]';

    p12=Pset(3,:)'-Pset(2,:)';
    p14=Pset(1,:)'-Pset(2,:)';

    n12=cross(e3,p12);
    n12=-n12/norm(n12);
    
    n14=cross(e3,p14);
    n14=n14/norm(n14);
    
    mu=-d/(1+n12'*n14);
    
    Q=Pset(2,:)+mu*(n12+n14)';

end

