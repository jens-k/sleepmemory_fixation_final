function mt_fixationTask(user)
% ** function mt_controlTask(user)
% This function initiates the fixation task.
%
% USAGE:
%     mt_fixationTask(user)
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% user              char       	pre-defined user name (see mt_loadUser.m)
%
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Load parameters specified in mt_setup.m
[dirRoot, dirPTB]   = mt_profile(user);

mt_window(dirRoot);
addpath(genpath(dirRoot));
load(fullfile(dirRoot, 'setup', 'mt_params.mat'))   % load workspace information and properties

%% Set window parameters
% Specify the display window 
window             = cfg_window.window(1);

%% Show instructions
mt_showText(dirRoot, textFixation, window);
mt_showText(dirRoot, textQuestion, window);

%% Show fixation cross 
HideCursor;

% Compute rectangle
fixRect = CenterRectOnPointd(dotSize, cfg_window.center(1), cfg_window.center(2));

% Draw the cross
imageDot	= Screen('MakeTexture', window, imgDot);
fixRect     = reshape(fixRect, 4, 1);
Screen('DrawTexture', window, imageDot, [], fixRect);
Screen('Flip', window, flipTime);
Screen('Close', imageDot);

    
WaitSecs(fixationDisplay);
ShowCursor(CursorType, window);
sca;

end