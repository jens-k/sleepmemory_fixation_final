function mt_run(user)
% function mt_run(user)
% ** mt_run(user)
% Runs the Memory Task (mt).
% The memory task consists of 30 cards which are displayed in 5 rows of 6
% cards each. The target card to search for is displayed at the top center 
% of the screen. There are two configurations of the cards - one for
% learning and recall, one for interference. The upper case letters
% correspond to the parameters in the dialogues at the start. The
% experiment consists of four phases:
%
% 1. Learning (L)
%    First, one has to remember the cards in the learning phase.
%    The cards are displayed one after another.
%
% 2. Immediate Recall (R)
%    The task is to find the card which shows the 
%    picture corresponding to the one displayed at the top center. 
%
% 3. Interference (I)
%    Prior to recall another configuration of cards will be displayed.
%
% 4. Recall (R)
%    Eventually the recall phase shows the same configuration as in the
%   Learning and Immediate Recall phase
%
% IMPORTANT: 
%  First you need to adjust the variables in "mt_setup.m"
%
% USAGE:
%       mt_run;         % works if directories in mt_setup are specified
%       mt_run('user'); % works if user in mt_loadUser is specified
%
% Notes: 
%   debug mode: type "debug" in input dialogue for subject number
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% user              char       	pre-defined user name (see mt_loadUser.m)
%
% 
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Prepare workspace
close all;              % Close all figures
clearvars -except user; % Clear all variables in the workspace
iRecall     = 0;        % counts the number of recall sessions needed
p_correct   = 0;        % initial value for percent correct clicked cards

if ~nargin
    user = [];
end

% Generate workspace variables defined in mt_setup.m
try
    rootdir = mt_setup(user);
catch ME
    fprintf(['Running mt_setup.m was unsuccessful.\n', ...
    'Check workspace variables and parameter settings.\n'])
    error(ME.message)
end

% Prompt to collect information about experiment
try
    mt_dialogues(rootdir);
catch ME
    fprintf(['Calling mt_dialogues was unsuccessful.\n', ...
        'Type "help mt_dialogues" and follow the instructions for configuration.\n'])
    error(ME.message)
end

% Include Psychtoolbox to the path and open a fullscreen window
% TODO: Window management: do we want two screens to show different information (experimenter vs. subject)?
try
    sca;                % Clear all features related to PTB
    cfg_window          = mt_window(rootdir);
    window              = cfg_window.window(1);
catch ME
    fprintf(['Opening a fullscreen window using Psychtoolbox was unsuccessful.\n', ...
        'Check variable PTBdir in mt_setup and check configuration of graphics card/driver.\n'])
    error(ME.message)
end

% Load workspace information and properties
try
    load(fullfile(rootdir, 'setup', 'mt_params.mat'))
catch ME
    fprintf(['mt_params.mat could not be loaded.\n', ...
        'Check the save destination folder in mt_setup.m and parameter settings.\n'])
    error(ME.message)
end

% Show introduction screen
mt_showText(rootdir, introText, window);
pause

%% Show which session is upcoming
mt_showText(rootdir, sessionText{cfg_dlgs.sesstype}, window);
pause

%% Prepare Card Matrix
mt_setupCards(rootdir, cfg_window);

%% Start the game
if cfg_dlgs.sesstype == 4
    % Start Control Task
    mt_controlTask(rootdir, cfg_window);
else
    while p_correct < 60
        iRecall = iRecall + 1;
        % Start Experimental Task
        p_correct = mt_cardGame(rootdir, cfg_window, iRecall);
    end
end

% Show final screen
mt_showText(rootdir, outroText, window);
pause
sca
end