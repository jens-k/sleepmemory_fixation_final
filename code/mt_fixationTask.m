function mt_fixationTask(dirRoot)
% ** function mt_controlTask(dirRoot, cfg_window)
% This function initiates the fixation task.
%
% USAGE:
%     mt_fixationTask(dirRoot)
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% dirRoot           char        path to root working directory
%
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Load parameters specified in mt_setup.m
mt_window(dirRoot);
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
fixRect = CenterRectOnPointd(crossSize, cfg_window.center(1), cfg_window.center(2));

% Draw the cross
imgCrossTex = Screen('MakeTexture', window, imgCross);
fixRect = reshape(fixRect, 4, 1);
Screen('DrawTexture', window, imgCrossTex, [], fixRect);
Screen('Flip', window, flipTime);

    
WaitSecs(fixationCrossDisplay);
ShowCursor;

end