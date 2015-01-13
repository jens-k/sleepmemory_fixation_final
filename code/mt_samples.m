%% Workspace
% Clear the workspace and the screen
close all;
clear all;
sca; 	% clear all features related to PTB

% Perform standard setup for PTB: 
% 0 - check mex file for Screen()
% 1 - additionally check mapping of key codes to key names
% 2 - additionally normalize color range from [0 255] to [0 1]
PsychDefaultSetup(2);

% Get screens connected
screens 		= Screen('Screens');

% Perform on external screen if available
screenNumber 		= max(screens);

%% Screen

% 1. Window Properties
% window - opened window
% windowRect - position array [left top right bottom]
[window, windowRect] 	= PsychImaging('OpenWindow', screenNumber, 1);

% get the window center coordinates
[xCenter, yCenter] 	= RectCenter(windowRect);

% Text properties
Screen('TextFont', window, 'Arial');
Screen('TextSize', window, 50);


%% Timing

% Measure the vertical refresh rate of the monitor
ifi 			= Screen('GetFlipInterval', window);
waitframes 		= 1;
topPriorityLevel 	= MaxPriority(window);
Priority(topPriorityLevel);
vbl 			= Screen('Flip', window);

% the code
% FIXME: 'the code'? :)
% flip
vbl 			= Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
Priority(0);

%% Text

% Text output of mouse position draw in the centre of the screen
DrawFormattedText(window, textString, 'center', 'center', white);

%% Mouse

% Get the current position of the mouse
[x, y, buttons] 	= GetMouse(window);