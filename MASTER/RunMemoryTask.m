%% Memory task

%% Prepare workspace
% Clear the workspace and the screen
close all;
clear all;
sca; % clear all features related to PTB
cfg_window = [];

% prepare and open the window on the screen
cfg_window = PTB_window();

% to 4:3
cfg_window.window(end-1:end) = [1024, 768];

% draw the cards
PTB_cards(cfg_window);

% Type "sca" and hit enter if the window freezes
commandwindow