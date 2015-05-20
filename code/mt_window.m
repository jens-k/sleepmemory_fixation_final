function cfg_window = mt_window(dirRoot)
% ** function mt_window
% This function opens a fullscreen window and performs a test to estimate
% the timing of the Psychtoolbox command Screen('Flip'). The variables are
% stored in mt_params.mat
%
% USAGE:
%     cfg_window = mt_window(dirRoot);
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% dirRoot           char        path to root working directory
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
load(fullfile(dirRoot,'setup','mt_params.mat'))   % load workspace information and properties

%% Perform standard setups for PTB: 
% 0 - Check mex file for Screen()
% 1 - Additionally check mapping of key codes to key names
% 2 - Additionally normalize color range from [0 255] to [0 1]
PsychDefaultSetup(2);

% Get screens connected
screens = Screen('Screens');

% If no screen is pre-specified, display on external screen if available
if ~exist('screenNumber', 'var')
    screenNumber = max(screens);
end

%% 1. Get Window Properties
%       window - opened window
%       windowRect - position array [left top right bottom]
Screen('Preference', 'VisualDebugLevel', 1);
Screen('Preference', 'ScreenToHead', 0, 0, 0);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, screenBgColor);
% DEBUG MODE
% [window, windowRect] = Screen('OpenWindow', screenNumber, [], [30 30 1024 768]);

windowRect  = get(0, 'MonitorPositions');
% Get the window center coordinates
[xCenter, yCenter] = RectCenter(windowRect);

% Format output
cfg_window.screen = [screens, screenNumber];
cfg_window.window = [window, windowRect];

% Assure 4:3 format
cfg_window.window43 = windowSize;
% cfg_window.window43(end-1:end) = windowSize;
cfg_window.center = [xCenter, yCenter];

%% 2. Set global screen properties
% Activate alpha channel for transparency & smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Set Text Font
Screen('TextFont', window, textDefFont);

% Set Cursor
ShowCursor(CursorType, window);

% % Set Priority
% if strcmp(priority_level, 'max')
%     priority_level = MaxPriority(window);
% else
%     priority_level = priority;
% end

%% 3. Perform Timing tests
ifi                 = Screen('GetFlipInterval', window);
waitframes          = 1;
Priority(priority_level);
vbl                 = Screen('Flip', window);
Priority(0);
flipTime            = vbl + (waitframes - 0.5) * ifi;

%% Save information about display timing in dirRoot
save(fullfile(dirRoot, 'setup', 'mt_params.mat'), '-append', 'flipTime', 'cfg_window')

end