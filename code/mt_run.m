% ** mt_run
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
% USAGE: 
%  1) First you need to adjust the variables in "mt_setup.m"
%  2) Type "mt_run" in the command window
%
% Notes: 
%   Type "sca" and hit enter if the window freezes
%   debug mode: type "debug" in input dialogue for subject number
%
% 
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Prepare workspace
close all;              % Close all figures
clear all;              % Clear all variables in the workspace

% Generate workspace variables defined in mt_setup.m
try
    rootdir = mt_setup;
catch ME
    error(ME.message)
    sprintf(['Running mt_setup.m was unsuccessful.', ...
        'Check workspace variables and parameter settings.'])
end

% Load workspace information and properties
try
    load(fullfile(rootdir,'code','mt_params.mat'))
catch ME
    error(ME.message)
    sprintf(['mt_params.mat could not be loaded.', ...
        'Check the save destination folder in mt_setup.m and parameter settings.'])
end

% Prompt to collect information about experiment
try
    mt_dialogues(rootdir);
catch ME
    error(ME.message)
    sprintf(['Calling mt_dialogues was unsuccessful.', ...
        'Type "help mt_dialogues" and follow the instructions for configuration.'])
end

% Include Psychtoolbox to the path and open a fullscreen window
% TODO: Window management: do we want two screens to show different information (experimenter vs. subject)?
try
    addpath(PTBdir)
    sca;                % Clear all features related to PTB
    cfg_window          = mt_window(rootdir);
    window              = cfg_window.window(1);
catch ME
    error(ME.message)
    sprintf(['Opening a fullscreen window using Psychtoolbox was unsuccessful.', ...
        'Check variable PTBdir in mt_setup and check configuration of graphics card/driver.'])
end

% Show introduction screen
mt_showIntro(rootdir, window)
KbWait;

% Start the experiment
performance = mt_cards(rootdir, cfg_window);

% Allow to type in the command window
commandwindow