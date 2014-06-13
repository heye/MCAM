function [ erg, alpha ] = crossPE( P, Q )
%CROSSPE this function evaluates if a line in Y direction through point P
%intersects with line Q
%   P=[0;
%      0]
%
%   Q=[0 1
%      0 1]
%
%   Q is a line from (0,0) to (1,1)
%   
%   [ erg, alpha ] = crossPE(P,Q) returns 0<alpha<1 if an intersection exists and the
%   intersection point erg

    %richtung der intersection line
    R=[0 1]';

    if P-Q(:,1) == [0 0]'
        erg = [0 0]';
        alpha = 0;
        return;
    end
    
    A=[R, Q(:,1)-Q(:,2)];
    if det(A) == 0
        erg = [nan nan];
        alpha = Inf;
        return;
    end
    b=Q(:,1)-P;
    
    
    
    dist = A\b;
    
    alpha = dist(2);
    %erg = Q(:,1)+alpha*(Q(:,2)-Q(:,1))
    erg = P+dist(1)*R;


    
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

