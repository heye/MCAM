function [ Gout ] = waterlineLayer( G, options )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


    %% preparations
    d=options.CutterDia;    
    if size(d,1)~=1 || size(d,2)~=1
        error('invalid CutterDia value, see CAMset() for more details about options');
    end
    n=length(G.children);

    Gout=graph([]);
        
    %save travel heigth
    ZTravel=options.ZTravel;
    if isempty(ZTravel)
        ZTravel=10;
        warning('empty ZTravel');
    end
    
    %% parallel paths erstellen
    GParallel=graph([]);
    if options.ClearArea == 1         
        % preparing graph
        xMin=0;
        xMax=xMin;
        yMin=0;
        yMax=yMin;
        for i=1:length(G.children)
            if G.children(i).inner
                %1.5*d damit etwas abstand zwischen finish und parallel path
                %ist
                Gw.children(i)=innerG(G.children(i), 1.5*d/2);
                while isempty(Gw.children(i).data) && i<length(G.children)
                    i=i+1;
                    Gw.children(i)=innerG(G.children(i), 1.5*d/2);
                    warning('leerer innerG');
                end
                 
                if options.verbose==1
                    %Gf.children(i)=innerG(G.children(i), d);
                    plot3Graph(G.children(i),G.zLevel,'r');
                    plot3Graph(Gw.children(i),G.zLevel,'m');
                    %plot3Graph(Gf.children(i),0,'k');
                end
                
            else            
                %1.5*d damit etwas abstand zwischen finish und parallel path
                %ist
                Gw.children(i)=outerG(G.children(i), 1.5*d/2);
                while isempty(Gw.children(i).data) && i<length(G.children)
                    i=i+1;
                    Gw.children(i)=outerG(G.children(i), 1.5*d/2);
                    warning('leerer outerG');
                end
                 
                if options.verbose==1
                    plot3Graph(G.children(i),G.zLevel);
                    plot3Graph(Gw.children(i),G.zLevel,'m');
                    %Gf.children(i)=outerG(G.children(i), d);
                    %plot3Graph(Gf.children(i),0,'k');
                end


                tMin=min(Gw.children(i).data(:,1));
                if xMin > tMin
                    xMin= tMin;
                end
                tMax=max(Gw.children(i).data(:,1));
                if xMax < tMax
                    xMax=tMax;
                end
                tMin=min(Gw.children(i).data(:,2));
                if yMin > tMin
                    yMin= tMin;
                end
                tMax=max(Gw.children(i).data(:,2));
                if yMax < tMax
                    yMax=tMax;
                end
            end
        end 
        Gw.children(end+1).data=[xMin, yMin, G.zLevel;
                                      xMin, yMax, G.zLevel;
                                      xMax, yMax, G.zLevel;
                                      xMax, yMin, G.zLevel;
                                      xMin, yMin, G.zLevel;];
%         close all
%         Gw.data=[];
%         plot3dGraph(Gw);   
%         xMax
%         yMax
%         xMin
%         yMin
%         pause
        %x intersection lines            
        x=linspace(xMin, xMax, (xMax-xMin)/(0.95*d));

        
        clearAreaGraph=graph([]);
        numLines=0;
        %get intersection points
        for i=1:length(x)
            p=[];
            for j=1:n+1
                E=[x(i) 0; x(i) 1]';
                ptemp=crossGE(Gw.children(j), E);
                if size(ptemp,1) > 0
                    p(end+1:end+size(ptemp,1),:)=ptemp;
                end
            end
            %TODO: graphen erstellen
            if size(p,1) > 0
                p=sort(p);
                if mod(length(p),2) 
                    warning('BUG: p uneven length!');
                end
                
                
                for j=1:2:length(p)-1
                    clearAreaGraph.children(numLines+1).data=[p(j:j+1,:),G.zLevel*ones(2,1)];
                    numLines=numLines+1;
                end
                
                %conventional -> von oben nach unten
                %climb milling -> von unten nach oben 
                
%                 for j=1:2:length(p)-1
%                     %cutter zur startposition fahren
%                     GParallel.data(end+1,:)=[x(i), p(j,2), ZTravel];
%                     %cutter absenken
%                     GParallel.data(end+1,:)=[x(i), p(j,2), G.zLevel];
%                     %zum endpunkt fahren
%                     GParallel.data(end+1,:)=[x(i), p(j+1,2), G.zLevel];
%                     %cutter anheben
%                     GParallel.data(end+1,:)=[x(i), p(j+1,2), ZTravel];
%                 end

%                 plot(p(:,1),p(:,2), 'x');
%                 hold on
            end
        end
        
        GParallel=mergeParallelPaths(clearAreaGraph,ZTravel,options.CutterDia);
        
        
        Gout.data(end+1:end+size(GParallel.data,1),:)=GParallel.data;
        
%         plot3dGraph(GParallel);
%         pause
%         Gout=GParallel;
%         return

    end
    %% waterline finish    
    % outline
%     figure;
%     plot3dGraph(G,'m');
    for i=1:length(G.children)
        if G.children(i).inner
            Gf.children(i)=innerG(G.children(i), d/2);
        else
            Gf.children(i)=outerG(G.children(i), d/2);
        end
    end
%     Gf.data=[];
%     plot3dGraph(Gf,'m');
%     axis equal
    
    for i=1:length(Gf.children)
        %cutter zum startpunkt fahren
        Gout.data(end+1,:)=[Gf.children(i).data(1,1:2),ZTravel];
        
        %graph anh?ngen
        Gout.data(end+1:end+size(Gf.children(i).data,1),:)=Gf.children(i).data;
        
        %Cutter anheben
        Gout.data(end+1,:)=[Gout.data(end,1:2),ZTravel];
    end
    
    if options.verbose==1
        plot3dGraph(Gout,G.zLevel);
        plot3(Gout.data(end,1),Gout.data(end,2),Gout.data(end,3),'rx');
        plot3(Gout.data(1,1),Gout.data(1,2),Gout.data(1,3),'gx');
    end
    
    
    %Gout=G;
end

