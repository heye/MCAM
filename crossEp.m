function [ erg, p ] = crossEp( P, Q )
%CROSSEP this function evaluates if two lines intersect
%   P=[0 1
%      0 1]
%
%   P is a line from (0,0) to (1,1)
%   
%   [ erg, p ] = CROSSEP(P,Q) 
%   erg=1 => lines P,Q intersect
%   erg=0 => no intersection
%
%   p is the point of the intersection
    
        p = [nan nan]';

    % gleicher startpunkt
    if P(:,1)-Q(:,1) == [0; 0]
        erg = 0;
        return;
    end
    
    %parallel 
    A=[P(:,2)-P(:,1), Q(:,1)-Q(:,2)];
    if det(A) == 0
        erg = nan;
        return;
    end
    b=Q(:,1)-P(:,1);
    
    
    
    dist = A\b;
    
    
    p=P(:,1)+dist(1)*(P(:,2)-P(:,1));
    %punkt liegt auf P
    if 0 < dist(1) && dist(1) < 1
        erg=1;
    else
        erg=0;
    end
    
    %erg = Q(:,1)+alpha*(Q(:,2)-Q(:,1))
    %erg = P(:,1)+dist(1)*(P(:,2)-P(:,1));


    
%     A=[PD(:, 2)-PD(:,1), L2(:,1)-L2(:,2)]
%     b=L2(:,1)-PD(:,1);
%     
%     
%     
%     dist = A\b;
%     
%     alpha = dist(2);
%     erg = L2(:,1)+alpha*(L2(:,2)-L2(:,1));
    
end

