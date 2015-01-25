function cfg_window = mt_window
% ** function mt_window
% This function opens a fullscreen window and performs a test to estimate
% the timing of the Psychtoolbox command Screen('Flip'). The variables are
% stored in mt_params.mat
%
% USAGE:
%     mt_window;
%
% <<< OUTPUT VARIABLES <<<
% NAME              TYPE        DESCRIPTION
% cfg_window        struct      contains window information
%   .screen         1X2 double  [screens ScreenNumber]
%   .window         1X5 double  [window windowRect], actual resolution
%   .window43       1X5 double  [window windowRect], 4:3 resolution
%   .center         1X2 double  [Xcenter Ycenter]
%
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Load parameters specified in mt_setup.m
load('mt_params.mat')   % load workspace information and properties

%% Perform standard setups for PTB: 
% 0 - Check mex file for Screen()
% 1 - Additionally check mapping of key codes to key names
% 2 - Additionally normalize color range from [0 255] to [0 1]
PsychDefaultSetup(2);

% Get screens connected
screens = Screen('Screens');

% Display on external screen if available
screenNumber = max(screens);

%% 1. Get Window Properties
%       window - opened window
%       windowRect - position array [left top right bottom]
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, 1);

% Get the window center coordinates
[xCenter, yCenter] = RectCenter(windowRect);

% Format output
cfg_window.screen = [screens, screenNumber];
cfg_window.window = [window, windowRect];

% Assure 4:3 format
cfg_window.window43 = cfg_window.window;
cfg_window.window43(end-1:end) = windowSize;
cfg_window.center = [xCenter, yCenter];

%% 2. Perform Timing tests
ifi                 = Screen('GetFlipInterval', window);
waitframes          = 1;
topPriorityLevel 	= MaxPriority(window);
Priority(topPriorityLevel);
vbl                 = Screen('Flip', window);
Priority(0);
flipTime            = vbl + (waitframes - 0.5) * ifi;

%% Save information about display timing in workdir
save('mt_params.mat', '-append', 'flipTime')

end