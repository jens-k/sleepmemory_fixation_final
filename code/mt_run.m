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
%    First, one has to remember cards of the main memory set in the 
%    learning phase.
%    The cards are displayed one after another.
%
% 2. Immediate Recall (R)
%    The task is to find the card which shows the 
%    picture corresponding to the one displayed at the top center. 
%
% 3. Interference (I)
%    Prior to recall another interference configuration of cards will be 
%    learned.
%
% 4. Recall (R)
%    Eventually, the recall phase shows the same configuration as in the
%    Learning and Immediate Recall phase
%
% Note the potential confusion arising from the phase 'Learning' refering
% to both learning and immediate recall of the main memory, while also the
% phase 'Interference' has a learning and immediate recall session.
% TODO: Sollen wir diese Verwirrung auflösen und die erste Phase "Main"/M
% nennen?
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

%% PREPARE WORKSPACE & REQUEST USER INPUT
close all;                  % Close all figures
clearvars -except user;     % Clear all variables in the workspace
iRecall         = 1;        % counter for recall sessions
perc_correct    = 0;        % initial value for percent correct clicked cards

% Initialize workspace; includes user dialogues
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

% TODO: Delete if possible
% Fixation task
% mt_showText(dirRoot, textFixation, window);
% mt_showText(dirRoot, textQuestion, window);
% mt_fixationTask(dirRoot, cfg_window);


%% START GAME   

% CONTROL
if strcmpi(cfg_cases.sesstype{cfg_dlgs.sesstype}, 'c')
    % Show introduction screen
    mt_showText(dirRoot, textControl, window);
    mt_showText(dirRoot, textQuestion, window);
    % Start Control Task
    for cRun = 1: length(controlList)
        mt_controlTask(dirRoot, cfg_window, cRun);
    end
    
% LEARNING and IMMEDIATE RECALL (learning & interference memory)
elseif strcmpi(cfg_cases.sesstype{cfg_dlgs.sesstype}, 'l') ...
        || strcmpi(cfg_cases.sesstype{cfg_dlgs.sesstype}, 'i')
    % Show introduction screen
    mt_showText(dirRoot, textLearning, window);
    if strcmpi(cfg_cases.sesstype{cfg_dlgs.sesstype}, 'l')
        % Start practice session
        mt_cardGamePractice(dirRoot, cfg_window);
    end
    mt_showText(dirRoot, textLearning2, window);
    mt_showText(dirRoot, textQuestion, window);
    % Start learning sessions
    for lRun = 1: nLearningSess
        mt_cardGame(dirRoot, cfg_window, iRecall);
    end
    % Start immediate recall
    while (iRecall < nMaxRecall) && ((100*perc_correct < 60) || (iRecall < nMinRecall)) 
        % Start Experimental Task
        perc_correct = mt_cardGame(dirRoot, cfg_window, iRecall, 1, 4);
        iRecall = iRecall + 1;
    end
    if (iRecall < nMaxRecall) && (100*perc_correct > 60)
        % start recall without feedback
        mt_showText(dirRoot, textRecallNoFeedback, window);
        perc_correct = mt_cardGame(dirRoot, cfg_window, iRecall, 0, 4);
    elseif (iRecall >= nMaxRecall)
        sprintf('Maximum number of recall runs reached. Experiment cancelled.')
        sca;
    end
    
% FINAL RECALL
else
    % Show introduction screen
    mt_showText(dirRoot, textRecall, window);
    mt_showText(dirRoot, textRecallNoFeedback, window);
    mt_showText(dirRoot, textQuestion, window);
    while (iRecall < nFinalRecall) 
        % Start Experimental Task
        perc_correct = mt_cardGame(dirRoot, cfg_window, iRecall, 0, 4);
        iRecall = iRecall + 1;
    end
    % Show final screen
    mt_showText(dirRoot, textOutro, window);
end
sca;
end