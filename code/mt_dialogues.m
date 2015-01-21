function mt_dialogues
%% TODO: Documentation
% copy newid.m to folder given by "which -all inputdlg" 
% http://www.mathworks.com/matlabcentral/answers/uploaded_files/1727/newid.m

load('mt_params.mat')   % load workspace information and properties

% read in dialogue questions
fid                 = fopen('prompts.txt');
prompts             = textscan(fid,'%s','Delimiter','\n');
prompts             = prompts{1};
fclose(fid);
% read in dialogue default answers
fid                 = fopen('defaults.txt');
defaults            = textscan(fid,'%s','Delimiter','\n');
defaults            = defaults{1};
fclose(fid);
% pre-allocate cell array for answer strings
answers             = cell(length(prompts),1);

% open dialogue windows
for p = 1 : length(prompts)
    answers{p,:} 	= newid(prompts(p), '', [1 70], defaults(p));
end

% label answers
cfg_dlgs.subject 	= char(answers{1, 1}); % 
cfg_dlgs.night      = char(answers{2, 1}); % 
cfg_dlgs.memvers    = char(answers{3, 1}); % 
cfg_dlgs.sesstype 	= char(answers{4, 1}); % 
cfg_dlgs.lab        = char(answers{5, 1}); % 

% evaluate answers
% memory version
switch cfg_dlgs.memvers
    case 'A' 
        cfg_dlgs.memvers = 1; % Learning
    case 'B'
        cfg_dlgs.memvers = 2; % Interference
    otherwise
        error('Invalid Memory Version')
end
% session type
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
% lab
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

cd(workdir)
save('mt_params.mat', '-append', 'cfg_dlgs')

end