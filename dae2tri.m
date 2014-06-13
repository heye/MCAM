function [triangles] = dae2tri(path, options)
%DAE2TRI reads a COLLADA xml file and returns a struct of triangles
%   triangles = DAE2TRI( 'path', 'options' )
%   for more info about options see 'help daeset'

dispProgress=0;
dispPlot=0;
if nargin < 2
else
    if isfield(options, 'display') && strcmp(options.display,'true')
        dispProgress=1;
    end
    if isfield(options, 'plot') && strcmp(options.plot,'true')
        dispPlot=1;
    end
end

startT=now;

s=xml2struct(path);


%tic
%s=xml2struct('Motormount.dae');
%toc

%find triangles
%[tr] = search(s,'triangles');
%find sources
%[src] = search(s,'source');
%find vertexes
%[vert] = search(s,'vertices');


%file in meshes aufteilen
%tic
[mesh] = searchXML(s, 'mesh');
%toc
if dispProgress
    fprintf('#### found %d meshes!!! ####\n', length(mesh));
end

%initialisierungen
triangles=struct('children', struct('data', []));
numTri=0;
numTex=0;
numVert=0;

%durch alle meshes iterieren
for l=1:length(mesh)
    %find triangles
    [tr] = searchXML(mesh(l),'triangles');
    %find sources
    %[src] = search(mesh(l),'source');
    %find vertexes
    %[vert] = search(mesh(l),'vertices');

    
    %% TODO <lines>

    %% <triangles>
    for i=1:length(tr)  
        %fprintf('triangle block %d',i);
        %tr
        %finde p

        for j=1:length(tr(i).Children)
            if tr(i).Children(j).Name=='p'
                p=tr(i).Children(j);
            end
        end
        p = str2num(p.Children.Data)';

        %finde input
        for j=1:length(tr(i).Children)
            if strcmp(tr(i).Children(j).Name,'input')
                input=tr(i).Children(j);
            end
        end
        %finde source id in input
        for j=1:length(input.Attributes)
            if strcmp(input.Attributes(j).Name,'source')
                id=input.Attributes(j).Value;
            end
        end
        VERTid=id(2:length(id));
        %input semantic finden
        for j=1:length(input.Attributes)
            if strcmp(input.Attributes(j).Name,'semantic')
                sem=input.Attributes(j).Value;
            end
        end
        %sem;
    
        %% TODO: TEXCOORD
        if strcmp(sem,'TEXCOORD')
            numTex=numTex+1;
        end

        %% VERTEX
        if strcmp(sem,'VERTEX')
            numVert=numVert+1;
%             vertices=[];
            
            
            
            
            % ###########POSITION############
            
            %finde vertices mit der richtigen id
            v=searchXMLValue(mesh(l),'id', VERTid);
            %finde position input
            POSinput=searchXMLValue(v, 'semantic', 'POSITION');

            %finde id der position source     
            POSid=getAttributeValue(POSinput, 'source');
            %erstes zeichen vom string ist eine '#' -> abschneiden
            POSid=POSid(2:length(POSid));

            %finde source mit der richtigen id
            POSsrc = searchXMLValue(mesh(l),'id', POSid);

            %finde float_array
            flArr = searchXML(POSsrc, 'float_array');
            flArr = str2num(flArr.Children.Data)';
            %skaliere float_array
            flArr=25.4*flArr;
            
            
            %koordinaten aus flArr
            for j=0:1:(length(flArr)/3)-1
                P(j+1,1:3)=[flArr(j*3+1), flArr(j*3+2), flArr(j*3+3)];
            end


            
            
            
            % ##########NORMAL##########
            %finde vertices mit der richtigen id
            v=searchXMLValue(mesh(l),'id', VERTid);
            %finde position input
            POSinput=searchXMLValue(v, 'semantic', 'NORMAL');
            
            %finde id der normal source     
            NORMid=getAttributeValue(POSinput, 'source');
            %erstes zeichen vom string ist eine '#' -> abschneiden
            NORMid=NORMid(2:length(NORMid));

            %finde source mit der richtigen id
            NORMsrc = searchXMLValue(mesh(l),'id', NORMid);

            %finde float_array
            normFlArr = searchXML(NORMsrc, 'float_array');
            normFlArr = str2num(normFlArr.Children.Data)';
            
            
            %koordinaten aus flArr
            for j=0:1:(length(normFlArr)/3)-1
                Pnorm(j+1,1:3)=[normFlArr(j*3+1), normFlArr(j*3+2), normFlArr(j*3+3)];
            end


            
            
            
            % #########setze dreiecke zusammen########
            p=p+ones(length(p),1);   %indizes auf matlab anpassen
            
            tmp=numTri;
            for j=0:(length(p)/3)-1
                vect=[P(p(3*j+1),:); P(p(3*j+2),:); P(p(3*j+3),:)];
                normVect=[Pnorm(p(3*j+1),:); Pnorm(p(3*j+2),:); Pnorm(p(3*j+3),:)];
                numTri=numTri+1;
                triangles.children(numTri).data=vect;
                triangles.children(numTri).norm=normVect;
            end        
            
            
            if dispProgress
                fprintf('found %d VERTEX triangles in mesh %d \n', numTri-tmp, l);
            end
            
            
            

        end
        %tr(i).Attributes.Value
    end


end
endT=now;
if dispProgress
    fprintf('found total %d triangles in %f seconds\n', numTri, (endT-startT)*10^5);
end
if dispPlot
    plotTriangles(triangles);    
end