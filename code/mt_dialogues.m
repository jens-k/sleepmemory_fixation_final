function mt_dialogues
% ** function mt_dialogues
% This script creates dialogue windows to configure the experiment. The
% questions and defaults can be found and adjustet in "prompts.txt" and
% "defaults.txt", respectively. Note that each line corresponds to one
% dialogue.
%
% IMPORTANT: For this script to work you have to copy the function "newid.m"
% to folder displayed if you execute "which -all inputdlg" 
% Source: http://www.mathworks.com/matlabcentral/answers/uploaded_files/1727/newid.m
%
% USAGE:
%     mt_dialogues;
%
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Load parameters specified in mt_setup.m
load('mt_params.mat')   % load workspace information and properties

%% Read in questions/default answers shown in the dialogue windows
% Read in dialogue questions
fid                 = fopen('prompts.txt');
prompts             = textscan(fid,'%s','Delimiter','\n');
prompts             = prompts{1};
fclose(fid);
% Read in dialogue default answers
fid                 = fopen('defaults.txt');
defaults            = textscan(fid,'%s','Delimiter','\n');
defaults            = defaults{1};
fclose(fid);
% Pre-allocation of cell array for answer strings
answers             = cell(length(prompts),1);

%% Show dialogue windows and save the answers
for p = 1 : length(prompts)
    answers{p,:} 	= newid(prompts(p), '', [1 70], defaults(p));
end

% Store answers in struct fields
cfg_dlgs.subject 	= char(answers{1, 1}); % Subject ID
cfg_dlgs.night      = char(answers{2, 1}); % Night number
cfg_dlgs.memvers    = char(answers{3, 1}); % Memory version
cfg_dlgs.sesstype 	= char(answers{4, 1}); % Session type
cfg_dlgs.lab        = char(answers{5, 1}); % Lab

%% Evaluate the answers to set memory version, session type, and lab
% Memory version
switch cfg_dlgs.memvers
    case 'A' 
        cfg_dlgs.memvers = 1; % Learning
    case 'B'
        cfg_dlgs.memvers = 2; % Interference
    otherwise
        error('Invalid Memory Version')
end

% Session type: defines cardSequence
switch cfg_dlgs.sesstype
    case 'L' 
        cfg_dlgs.sesstype = 1; % Learning
    case 'R'
        cfg_dlgs.sesstype = 2; % Recall
    case 'I'
        cfg_dlgs.sesstype = 3; % Interference
    otherwise
        error('Invalid Session Type')
end

% Lab
switch cfg_dlgs.lab
    case 'M' 
        cfg_dlgs.lab = 1;
        % TODO: set triggers for MEG
        % In the MEG will be the old olfactometer
    case 'S'
        cfg_dlgs.lab = 2;
        % TODO: set triggers for sleep lab
        % In the sleep lab will be the new olfactometer
    otherwise
        error('Invalid Lab')
end

%% Save configuration in workdir
cd(workdir)
save('mt_params.mat', '-append', 'cfg_dlgs')

end