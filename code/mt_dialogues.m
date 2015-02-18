function cancel = mt_dialogues(dirRoot)
% ** function mt_dialogues(dirRoot)
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
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% dirRoot           char        path to root working directory
%
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Load parameters specified in mt_setup.m

load(fullfile(dirRoot,'setup','mt_params.mat'))   % load workspace information and properties


%% Read in questions/default answers shown in the dialogue windows

% Read in dialogue questions
fid                 = fopen(fullfile(dirRoot,'code','prompts.txt'));
prompts             = textscan(fid,'%s','Delimiter','\n');
prompts             = prompts{1};
fclose(fid);

% Read in dialogue default answers
fid                 = fopen(fullfile(dirRoot,'code','defaults.txt'));
defaults            = textscan(fid,'%s','Delimiter','\n');
defaults            = defaults{1};
fclose(fid);

% Pre-allocation of cell array for answer strings
[answers{1:length(prompts)}] = deal(cell(1));
for r = 1:size(answers,2)
    answers{1, r}{:} = '';
end

%% Show dialogue windows and save the answers
dlgBackground = figure('name', 'dlgBackground', 'units', 'normalized', 'outerposition', [0 0 1 1] , 'Color', [1 1 1], ...
    'NumberTitle','off', 'menubar', 'none', 'toolbar', 'none', 'Color', 'white');
options.WindowStyle='modal';
for p = 1 : length(prompts)
    % allow only values as specified in cfg_cases (mt_setup.m)
    while (p == 1 && ~ismember(str2double(answers{p}), cfg_cases.subjects)) || ...
        (p == 2 && ~ismember(answers{2}(:), cfg_cases.nights))  || ...
        (p == 3 && ~ismember(answers{3}(:), cfg_cases.sesstype) || ...
        (p == 4 && ~ismember(answers{4}(:), cfg_cases.memvers)))|| ...
        (p == 5 && ~ismember(answers{5}(:), cfg_cases.lab))     || ...
        (p == 6 && ~ismember(answers{6}(:), cfg_cases.odor))  
        if p == 6 && strcmpi(char(answers{3}(:)), cfg_cases.sesstype{1})
            break;
        end
            answers{p} 	= upper(newid(prompts(p), '', [1 70], defaults(p), options));
        if isempty(answers{p})
            close('dlgBackground')
            error('Input cancelled')
        end
    end
    if str2double(answers{1}{:}) == 0
        load(fullfile(setupdir, 'mt_debug.mat'))
        break;
    end
end
close('dlgBackground')

% Store answers in struct fields
% Questions can be found in prompts.txt, defaults in defaults.txt
if ~exist('cfg_dlgs', 'var')
    cfg_dlgs.subject 	= char(answers{1}); % Subject ID
    cfg_dlgs.night      = char(answers{2}); % Night number
    cfg_dlgs.sesstype 	= char(answers{3}); % Session type
    cfg_dlgs.memvers    = char(answers{4}); % Memory version
    cfg_dlgs.lab        = char(answers{5}); % Lab
    cfg_dlgs.odor       = char(answers{6}); % Odor on or off
end

% save(fullfile(setupdir, 'mt_debug.mat'), 'cfg_dlgs') % uncomment for new debug mat-file

%% Evaluate the answers to set memory version, session type, and lab
% Create a new folder for the subject data
% subdir = fullfile('DATA',strcat('Subject_', cfg_dlgs.subject),strcat('Night_', cfg_dlgs.night));
% mkdir(fullfile(dirRoot,'DATA',strcat('Subject_', cfg_dlgs.subject)), ...
%         strcat('Night_', cfg_dlgs.night))

% Memory version
switch cfg_dlgs.memvers
    case cfg_cases.memvers{1} 
        cfg_dlgs.memvers = 1; % Version A of memory
    case cfg_cases.memvers{2}
        cfg_dlgs.memvers = 2; % Version B of memory
    otherwise
        error('Invalid Memory Version')
end

% Session type: defines cardSequence
switch cfg_dlgs.sesstype
    case cfg_cases.sesstype{1}
        cfg_dlgs.sessName = cfg_cases.sessNames{1};
        cfg_dlgs.sesstype = 1;
    case cfg_cases.sesstype{2} 
        cfg_dlgs.sessName = cfg_cases.sessNames{2};
        cfg_dlgs.sesstype = 2;
    case cfg_cases.sesstype{3}
        cfg_dlgs.sessName = cfg_cases.sessNames{3};
        cfg_dlgs.sesstype = 3;
    case cfg_cases.sesstype{4} 
        cfg_dlgs.sessName = cfg_cases.sessNames{4};
        cfg_dlgs.sesstype = 4;
    case cfg_cases.sesstype{5}    
        % gray background and no images are shown
        cfg_dlgs.sessName = cfg_cases.sessNames{5};
        screenBgColor   = 0.5;
        topCardColor    = 0.5;
        frameWidth      = 0;
        save(fullfile(dirRoot,'setup','mt_params.mat'), '-append', ...
            'screenBgColor', 'topCardColor', 'frameWidth')
        cfg_dlgs.sesstype = 5; 
    otherwise
        error('Invalid Session Type')
end

% Lab
switch cfg_dlgs.lab
    case cfg_cases.lab{1} 
        cfg_dlgs.lab = 1;
        % TODO: set triggers for MEG
        % Parallel port trigger in PTB
        % In the MEG will be the old olfactometer
    case cfg_cases.lab{2}
        cfg_dlgs.lab = 2;
        % TODO: set triggers for sleep lab (left)
        % In the sleep lab will be the new olfactometer
    case cfg_cases.lab{3}
        cfg_dlgs.lab = 3;
        % TODO: set triggers for sleep lab (right)
        % In the sleep lab will be the new olfactometer
        % Only in this lab one can learn and stimulate with odors
    otherwise
        error('Invalid Lab')
end

% Choose a control list based on the subject id
% nControlList            = mod(str2double(cfg_dlgs.subject), length(controlList.controlList))+1;
% controlList             = controlList.controlList(nControlList, :);

%% Save configuration in dirRoot
save(fullfile(setupdir,'mt_params.mat'), '-append', 'cfg_dlgs')

end