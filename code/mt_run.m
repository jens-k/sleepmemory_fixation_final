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
%       mt_run('user'); % works if user in mt_profile is specified
%
% Notes: 
%   debug mode: enter 0 (zero) in input dialogue for subject number
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% user              char       	pre-defined user name (see mt_profile.m)
%
% 
% AUTHOR: Marco Rüth, contact@marcorueth.com

% FIXME
Screen('Preference', 'SkipSyncTests', 1);

%% Prepare workspace
close all;                  % Close all figures
clearvars -except user;     % Clear all variables in the workspace
iRecall         = 1;        % counts the number of recall sessions needed
perc_correct    = 0;        % initial value for percent correct clicked cards

% workspace initialization
dirRoot         = mt_prepare(user); 

% Load workspace information and properties
try
    load(fullfile(dirRoot, 'setup', 'mt_params.mat'))
    window      = cfg_window.window(1);
catch ME
    fprintf(['mt_params.mat could not be loaded.\n', ...
        'Check the save destination folder in mt_setup.m and parameter settings.\n'])
    error(ME.message)
end

% Prepare Card Matrix
mt_setupCards(dirRoot, cfg_window);

%% Show introduction screen
mt_showText(dirRoot, textIntro, window);
pause

%% Start the game
if strcmpi(cfg_cases.sesstype{cfg_dlgs.sesstype}, 'c')
    % FOR TESTING
    controlList = 4; 
    % Start Control Task
    for cRun = 1: length(controlList)
        mt_controlTask(dirRoot, cfg_window, controlList(cRun));
    end
elseif strcmpi(cfg_cases.sesstype{cfg_dlgs.sesstype}, 'l')
    % Start practice session
    mt_cardGamePractice(dirRoot, cfg_window);
    % Start two learning sessions
%     mt_cardGame(dirRoot, cfg_window, iRecall);
%     mt_cardGame(dirRoot, cfg_window, iRecall);
else
    while 100*perc_correct < 60 % iRecall >min & <max x calls of recall
        % Start Experimental Task
        perc_correct = mt_cardGame(dirRoot, cfg_window, iRecall);
        iRecall = iRecall + 1;
    end
    % if at least 60% are correct start one last recall session
    % this time no feedback is shown
    perc_correct = mt_cardGame(dirRoot, cfg_window, iRecall, 0);
end

% TODO: learning interference & recall interference
% TODO: x times learning & immediate recall together
% TODO: save all files in one folder
%% Show final screen
mt_showText(dirRoot, textOutro, window);
pause
sca

%% Create backup
if exist(fullfile(dirRoot, subdir), 'dir') && ...
        ~exist(fullfile(dirRoot, 'BACKUP', subdir), 'dir')
    mkdir(fullfile(dirRoot, 'BACKUP', subdir))
end
    copyfile(fullfile(dirRoot, subdir, 'mtp_sub_*'), fullfile(dirRoot, 'BACKUP', subdir), 'f');
end