%% mt_run
% First you need to adjust the variables in mt_setup.m
%% Prepare workspace
close all;              % Close all figures
clear all;              % Clear all variables in the workspace
sca;                    % Clear all features related to PTB
run('mt_setup.m')       % Creates workspace variables define in mt_setup.m
load('mt_params.mat')   % load workspace information and properties

% prompts to collect information about experiment
mt_dialogues;

% prepare and open the window on the screen
% TODO: Window management: do we want two screens to show different information (experimenter vs. subject)?
cfg_window          = mt_window();

% draw the cards
mt_cards(cfg_window);

% Type "sca" and hit enter if the window freezes
commandwindow