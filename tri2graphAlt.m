function [ graphs, intsecH ] = tri2graphAlt( tri, height )
%UNTITLED16 Summary of this function goes here
%   Detailed explanation goes here
    
    %% find max z component
    minZ=triMinZ(tri);

    %% reduce triangle count to relevant subset 
    intsecH = minZ + height;
    numTri=1;
    %triSubset=[];
    j=1;
    for i=1:length(tri.children)    
        triZmax=max(tri.children(i).data(:,3));
        triZmin=min(tri.children(i).data(:,3));
        if triZmin < intsecH && intsecH < triZmax
            triSubset.children(j)=tri.children(i);
            j=j+1;
        end
    end
    %no subset -> return
    if ~any(strcmp(who,'triSubset'))
        warning('empty triangle subset at %dmm!', intsecH);
        graphs=graph([]);
        return;
    end

%             plotTriangles(triSubset);
    %% generate graph edges  
    numP=1;
    for i=1:length(triSubset.children)
        % test all 3 edges of every triangle
%         ctri=struct('children', struct('data', triSubset.children(i).data));
%         plotTriangles(ctri, 'r');
        
        if triSlope(triSubset.children(i).norm) == 1
            E=[];
            warning('slope 0');
        else
            E=[];
            [p, alpha]=intsecEH([triSubset.children(i).data(1,:); triSubset.children(i).data(2,:)], intsecH);
            if 0 < alpha && alpha < 1
                E(size(E,1)+1, 1:3) = p;
                %P(numP,1:3)=p;
                %numP=numP+1;
            end
            [p, alpha]=intsecEH([triSubset.children(i).data(2,:); triSubset.children(i).data(3,:)],intsecH);
            if 0 < alpha && alpha < 1
                E(size(E,1)+1, 1:3) = p;
                %P(numP,1:3)=p;
                %numP=numP+1;
            end
            [p, alpha]=intsecEH([triSubset.children(i).data(3,:); triSubset.children(i).data(1,:)],intsecH);
            if 0 < alpha && alpha < 1
                E(size(E,1)+1, 1:3) = p;
                %P(numP,1:3)=p;
                %numP=numP+1;
            end

            %if size(E, 1) < 2
            %    warning('found only one node in triangle!')
            %end
            %neue edge an Edges Matrix anh?ngen
            Edges(numP:numP+size(E,1)-1,1:3)=E;
            numP=numP+size(E,1);
        end
%         E
%         plotEdges(E, 'g',intsecH);
%         pause
    end

    %% generate graph nodes from edges


    numP=3;
    numG=1;
    G=struct;
    originalEdges=Edges;
    
    %erste edge im graphen speichern
    G.children(numG).data(1:2,1:3)=Edges(1:2,:);
    %erste edge aus edge matrix entfernen
    Edges(1:end-2,1:3)=Edges(3:size(Edges,1),1:3);
    Edges(size(Edges,1)-1:size(Edges,1),:)=[];
    
%     emptye=0;
    %alle edges ablaufen
    numPE=0;
    
    while size(Edges,1) > 0
        
        %finde den 2. knoten der edge
        [E, v] = findNextNode(Edges, G.children(numG).data(numP-1,:));   
        
%         if size(E,1) == size(Edges,1)
%             emptye=1;
%             warning('edges not reduced');
%         else
%             emptye=0;
%         end
        
%         if size(E,1)-size(Edges,1) == 0 
%             warning('no edge removed');
%         end
        
%         while size(v,1) > 0 && sum(abs(v-G.children(numG).data(numP-1,:))) < 10^-5
%             numPE=numPE+1;
%             Edges=E;
%         	[E, v] = findNextNode(Edges, G.children(numG).data(numP-1,:));  
%             warning('point edge %d', G.children(numG).data(numP-1,1));
%         end
        
        % startpunkt!=endpunkt && v=[] -> graph nicht geschlossen
        if sum(abs(G.children(numG).data(numP-1,:)-G.children(numG).data(1,:))) > 10^-5 && size(v,1) == 0
            %% TOFIX irgendwo wird eine edge nicht gel?scht... maybe findNextNode
            
            warning('graph ist nicht geschlossen!!');
            close all
            Edges
            
            plotEdges(originalEdges, 'g', intsecH);
            %for i=1:numG-1
                plot3Graph(graph(G.children(numG-2).data), intsecH,'m');
                plot3Graph(graph(G.children(numG-1).data), intsecH,'rx');
            %end
            lastData=G.children(numG-1).data
            
            plot3Graph(graph(G.children(numG).data), intsecH,'x');
            plot3Graph(graph(G.children(numG).data), intsecH,'r');
            G.children(numG).data(numP-1,:)
            G.children(numG).data
            error('graph ist nicht geschlossen!!');
            pause
        end
        
        %n?chsten knoten gefunden -> anh?ngen und Edges k?rzen (nur wenn gefundener punkt nich
        %gleich gesuchter punkt, sont gibt es doppelte punkte im graphen)
%         if size(v,1) > 0
        if size(v,1) > 0 && sum(abs(v-G.children(numG).data(numP-1,1:3)))
            G.children(numG).data(numP,1:3)=v;
            numP=numP+1;
            Edges=E;
        else
            if size(v,1) > 0
            Edges=E;
            end
        end
        
        %% TODO: neuen punkt anfangen, wenn start= ende AUSSER start=suchpunkt gewesen | damit wird m?glicherweise das doppeltumlaufen verhindert 
        % startpunkt = endpunkt && v=[] (kein neuer knoten gefunden, da punkt knoten m?glich sind) -> graph vollst?ndig
        if sum(abs(G.children(numG).data(numP-1,:)-G.children(numG).data(1,:))) < 10^-5 && size(v,1) == 0
            % wenn kein knoten gefunden wurde, muss Edges noch
            
            
%             fprintf('###found a full graph!###\n');
%             fprintf('remaining Edges: %d\n',size(Edges,1));            
%             gr=G.children(numG).data
%             Edges            
            
            %noch weitere edges ?brig? -> neuen graphen anfangen
            if size(Edges,1) > 2
                
                numG=numG+1;
                %erste edge im graphen speichern
                G.children(numG).data(1:2,1:3)=Edges(1:2,:);
                numP=3;
                %start edge entfernen      
                Edges=Edges(3:end,:);
                %Edges(1:size(Edges,1)-2,1:3)=Edges(3:size(Edges,1),1:3); 
                %Edges(size(Edges,1)-1:size(Edges,1),:)=[];
            else
                warning('one edge left');
                Edges
                Edges=[];
            end
        end
%         if emptye==1 && size(Edges,1) == size(E,1);
%             E
%             Edges
%             G.children(numG).data(end,:)
%             error('edges not reduced');
%         end
%         end
    end
    
%     numPE
%     numG
%     close all
%     for i=1:numG
%         plot3Graph(graph(G.children(i).data), intsecH,'m');
%     end
%     pause
    
    %% reduce node count
    
%     G.children(1).data
    for i=1:length(G.children)
        %anzahl bereits entfernter knoten
        j=1;
        while j<=size(G.children(i).data,1)-2
            %wenn vektoren parallel -> knoten j+1 entfernen            
            
            v1=G.children(i).data(j+1,:)'-G.children(i).data(j,:)';
            v2=G.children(i).data(j+2,:)'-G.children(i).data(j+1,:)';
            if abs(cosV(v1,v2)-1)<10^-5
                G.children(i).data=[G.children(i).data(1:j,:);G.children(i).data(j+2:end,:)];                
            else
                %wenn ein knoten entfernt wurde, ist bereits ein neuer an
                %position j+2
                j=j+1;
            end
        end
        %erster und letzter knoten werden in der schleife nicht ?berpr?ft
            
        %spezialfall, wenn start/endpunkt auf einer line liegen, dann
        %muss neuer start/endpunkt gew?hlt werden!
        v1=G.children(i).data(end,:)'-G.children(i).data(end-1,:)';
        v2=G.children(i).data(2,:)'-G.children(i).data(end,:)';
        if abs(cosV(v1,v2)-1)<10^-5
            %bisherigen start/endpunkt entfernen
            G.children(i).data=G.children(i).data(2:end-1,:);
            G.children(i).data(end+1,:)=G.children(i).data(1,:);
        end
    end

    %% versehendlich erzeugte leere und ein punkt graphen entfernen, und ausgabe erzeugen
    % TODO: FIX dass die ?berhaut nicht erzeugt werden... DONE, hoffentlich
    
    graphs=graph([]);
    %graphs.children=G.children;

%     graphs=graph([]);
    j=1;
    for i=1:length(G.children)
        if size(G.children(i).data, 1) > 2
            graphs.children(j)=G.children(i);
            j=j+1;
        end
    end
    
    %% graphen die doppelt umlaufen (einmal recht, einmal links) in der
    % mitte unterbrechen
    for i=1:length(graphs.children)
        for j=2:size(graphs.children(i).data)-2
            if sum(abs(graphs.children(i).data(j,:)-graphs.children(i).data(1,:))) < 10^-5
                graphs.children(i).data=graphs.children(i).data(1:j,:);
                break;
            end
        end
    end
    
    %% sicher stellen, dass graphen mathematisch positiv umlaufen werden
    graphs=turnGraphPos(graphs);
    
        
        %graphen machen
    %G.dir=0;
    %G.data=[];
    %graphs=G;
end

