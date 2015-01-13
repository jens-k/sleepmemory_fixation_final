% typed characters don't show up
% FIXME: Does this line force characters not to show up? Or does it fix the bug that characters don't show up?
ListenChar(2);

%% Dialogue Input
cfg_prompts 		= [];

% get subject info
prompts 		= {'Enter subject number:','...','...'};
defaults 		= {'', '', ''};
answers 		= cell(length(prompts),1);

for p=1:length(prompts)
    answers{p,:} 	= inputdlg(prompts(p), 'Subject Number', 1, defaults(p));
end

% label answers
cfg_prompts.subject 	= char(answers{1, 1}); % 

%% Prepare workspace
% Clear the workspace and the screen
close all;
clear all;
sca; 	% clear all features related to PTB
cfg_window 		= [];

% prepare and open the window on the screen
% TODO: Window management: do we want two screens to show different information (experimenter vs. subject)?
cfg_window 		= PTB_window();

% draw the cards
PTB_cards(cfg_window);

% Type "sca" and hit enter if the window freezes
commandwindow
