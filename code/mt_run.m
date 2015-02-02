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
close all;                  % Close all figures
clearvars -except user;     % Clear all variables in the workspace
iRecall         = 1;        % counts the number of recall sessions needed
perc_correct    = 0;        % initial value for percent correct clicked cards

% workspace initialization
rootdir         = mt_prepare(user); 

% Load workspace information and properties
try
    load(fullfile(rootdir, 'setup', 'mt_params.mat'))
    window      = cfg_window.window(1);
catch ME
    fprintf(['mt_params.mat could not be loaded.\n', ...
        'Check the save destination folder in mt_setup.m and parameter settings.\n'])
    error(ME.message)
end

%% Show introduction screen
mt_showText(rootdir, textIntro, window);
pause

%% Show which session is upcoming
mt_showText(rootdir, textSession{cfg_dlgs.sesstype}, window);
pause

%% Prepare Card Matrix
mt_setupCards(rootdir, cfg_window);

%% Start the game
if cfg_dlgs.sesstype == 1
    % Start Control Task
    nControlCards = 4; % FOR TESTING
    mt_controlTask(rootdir, cfg_window, nControlCards); 
elseif cfg_dlgs.sesstype == 2
    % TODO: 2xlearning
    mt_cardGame(rootdir, cfg_window, iRecall);
else
    while 100*perc_correct < 60
        % Start Experimental Task
        perc_correct = mt_cardGame(rootdir, cfg_window, iRecall);
        iRecall = iRecall + 1;
    end
    % if at least 60% are correct start one last recall session
    % this time no feedback is shown
    perc_correct = mt_cardGame(rootdir, cfg_window, iRecall, 0);
end

%% Show final screen
mt_showText(rootdir, textOutro, window);
pause
sca

%% Create backup
if exist(fullfile(rootdir, subdir), 'dir') && ...
        ~exist(fullfile(rootdir, 'BACKUP', subdir), 'dir') && cfg_dlgs.sesstype ~= 2
    mkdir(fullfile(rootdir, 'BACKUP', subdir))
    copyfile(fullfile(rootdir, subdir, 'mtp_sub_*'), fullfile(rootdir, 'BACKUP', subdir), 'f');
end
end