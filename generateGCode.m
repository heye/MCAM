function [ GCode ] = generateGCode( tri, options, outputName )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
GCode=[];

    %% Z options
    if options.MagicZ == 1
        [z, minZ, maxZ]=flexLayerH(tri, options.ZSpacing, 0.1);
    else
        minZ=triMinZ(tri);
        maxZ=triMaxZ(tri);
        z=linspace(maxZ,minZ,(maxZ-minZ)/options.ZSpacing+1);
    end    
    
%     z=z(1:5);
    nLayer=length(z);
    
    %% preparations - calculate constants

    if isempty(options.ZTravel)
        warning('no ZTravel set, using default value ZTravel=10');
        options.ZTravel=10+maxZ;
    else
        options.ZTravel=options.ZTravel+maxZ;
    end
    
    
    %% create layer intersections with inner/outer, zlevel property from triangles
    G=[];
    G=graph([]);
    numG=1;
%     zMax=z(1); % untergrenze f?r obersten layer
    
    tstart=tic;
    for i=1:nLayer
        if options.verbose == 1
            %fprintf('i=%d\n',i);    
            fprintf('%d: layer height: %d\n',i,z(i));
        end
        [Gtemp,height]=tri2graphAlt(tri,z(i));
        
        %wenn daten vorhanden sind mache graph
                                                                            %TODO: einzelne children ?berpr?fen 
%         if size(Gtemp.children(1).data,1) > 0
%             G(numG)=Gtemp;
%             G(numG)=setInnerOuter(G(numG));
%             G(numG).zLevel=z(i);
%             numG=numG+1;       
%         end       
        numChildren=0;
        for j=1:length(Gtemp.children)
            if ~isempty(Gtemp.children(j).data)
                G(numG).children(numChildren+1)=Gtemp.children(j);
                numChildren=numChildren+1;
            else
                warning('BUG: leerer graph!! (ignore if empty triangle subset)');
            end
        end
        if numChildren > 0
            G(numG).children.data;
            
            G(numG)=setInnerOuter(G(numG));
            G(numG).zLevel=z(i);
            numG=numG+1;  
        end
    end
    nLayer=length(G);
    tend=tic;
    layeringTime=double(tend-tstart)*10^-9    
    
    %% verbose output: plot layer waterlines
    if options.verbose == 1
        figure;
        for i=1:length(G)
            for j=1:length(G(i).children)
                if G(i).children(j).inner == 1
                    plot3Graph(G(i).children(j),G(i).zLevel, 'r');
                else                    
                    plot3Graph(G(i).children(j),G(i).zLevel, 'b');
                end
            end
        end
        axis equal
        fprintf('press any key to continue');
        pause
    end
    
    %% x parallel finish
    if strcmp(options.Finish, 'ParallelX')
        
    end
%     
%     GCode=G(9);
%     return
       
    %% waterline finish
%     G(1).children.data
%     plot3dGraph(G(1));
    
%     GCode=G;
%     return;
    tstart=tic;
    if strcmp(options.Finish, 'Waterline')
        GCodeData=graph([]);
        for i=1:nLayer
            G(i)=waterlineLayer(G(i),options);
            
            %cutter zum startpunkt fahren
            GCodeData.data(end+1,:)=[G(i).data(1,1:2),options.ZTravel, 0];
            %graph anh?ngen
            GCodeData.data(end+1:end+size(G(i).data,1),:)=G(i).data;
            %Cutter anheben
            GCodeData.data(end+1,:)=[GCodeData.data(end,1:2),options.ZTravel,0];
        end
        %verschieben
        GCodeData.data(:,3)=GCodeData.data(:,3)-maxZ*ones(size(GCodeData.data,1),1);
        
%         fprintf('press any key to continue..');
%         pause
%         plot3dGraph(GCodeData);
    end
    tend=tic;
    WaterlineTime=double(tend-tstart)*10^-9
    
    postprocessorGRBL(GCodeData, options, outputName);
    GCode=GCodeData;
    %% TODO: post processing toolpath graph -> gcode
    
end

