function [ erg ] = crossE( P, Q )
%CROSSE this function evaluates if two lines intersect
%   P=[0 1
%      0 1]
%
%   P is a line from (0,0) to (1,1)
%   
%   [ erg ] = CROSSE(P,Q) returns 1 if an intersection exists or 0 if there is none
    

    % gleicher startpunkt
    if P(1,1)-Q(1,1) == 0 && P(2,1)-Q(2,1)  == 0 
        erg = [0 0]';
        return;
    end
    
    %parallel 
    A=[P(:,2)-P(:,1), Q(:,1)-Q(:,2)];
    %if det(A)==0
    if rcond(A) < 10^-14 || det(A)==0
        erg = nan;
        return;
    end
    b=Q(:,1)-P(:,1);
    
    
    
    dist = A\b;
    
    
    
    if 0 < dist(1) && dist(1) < 1 && 0 < dist(2) && dist(2) < 1 
        erg = 1;
    else
        erg = 0;
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

