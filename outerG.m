function [ outG ] = outerG( G, d )
%OUTERG generates an outer graph 
%   inG=OUTERG( 'G', 'd' ) generates an inner graph from G with spacing d

    outG=graph([]);
    for i=1:size(G.data,1)-2
        Q=outerQ(G.data(i:i+2,:), d);
        outG.data(i,:)=Q;
            %plot3Graph(graph(G(5).children(1).data(1:3,:)),height,'g');
            %plot3(Q(1),Q(2),Q(3), 'mx');
            %pause;
    end
    Q=outerQ([G.data(end-1,:); G.data(end,:); G.data(2,:)], d);
    outG.data(end+1,:)=Q;
    %graph schlie?en
    if ~isempty(outG.data)
        outG.data(end+1,:)=outG.data(1,:);
        outG.zLevel=outG.data(1,3);
    end
end

