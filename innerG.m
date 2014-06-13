function [ inG ] = innerG( G, d )
%INNERG generates an inner graph 
%   inG=INNERG( 'G', 'd' ) generates an inner graph from G with spacing d

    inG=graph([]);
    for i=1:size(G.data,1)-2
        Q=innerQ(G.data(i:i+2,:), d);
        inG.data(i,:)=Q;
            %plot3Graph(graph(G(5).children(1).data(1:3,:)),height,'g');
            %plot3(Q(1),Q(2),Q(3), 'mx');
            %pause;
    end
    Q=innerQ([G.data(end-1,:); G.data(end,:); G.data(2,:)], d);
    inG.data(end+1,:)=Q;
    %graph schlie?en
    if ~isempty(inG.data)
        inG.data(end+1,:)=inG.data(1,:);
        inG.zLevel=inG.data(1,3);
    end
end

