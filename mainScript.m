%% This script is an example on how to use MCAM 
%
%   Author: Heye Everts
%   Mail:   heye.everts.1@gmail.com
%
clear all;
close all;
clc;

options=daeset('','');
tic
% dae2tri parses a COLLADA file (*.dae) and returns a set of triangles
tri=dae2tri('picase_bottom.dae', options);
toc

% CAMset creates a list of settings, used in the generateGCode funktion 
options=CAMset('Finish','Waterline','ClearArea',1,'ZSpacing',3, 'MagicZ',1,'verbose',0,'CutterDia',2,'ZTravel',10);
options=CAMset(options,'FeedZTravel',200);
options=CAMset(options,'FeedXYTravel',400);
options=CAMset(options,'FeedZ',50);
options=CAMset(options,'FeedXY',200)
tstart=tic;
toc;
%generateGCode needs a set of triangles and options to create a g-code file
%and a graph Gtemp, that contains the complete toolpath
Gtemp=generateGCode(tri, options, 'out.gcode');
tend=tic;
GCodeTime=double(tend-tstart)*10^-9

plot3dGraph(Gtemp);




%% TODO
% 
% beispiel code h?bsch machen
% kommentare in englisch zu jeder funktion
% 
% code in repository schieben
% 
% feedrate einbauen
% 
%
%
%   TODO: BUGFIXES