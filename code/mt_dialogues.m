function cfg_dlgs = mt_dialogues()
%% TODO: Documentation
% copy newid.m to folder given by "which -all inputdlg" 
% http://www.mathworks.com/matlabcentral/answers/uploaded_files/1727/newid.m

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
        disp('A ok')
    case 'B'
        disp('B ok')
    otherwise
        error('Invalid Memory Version')
end
% session type
switch cfg_dlgs.sesstype
    case 'L' 
        disp('L ok')
        % Learning session equals immediate recall session
    case 'R'
        disp('R ok')
    case 'I'
        disp('I ok')
    otherwise
        error('Invalid Session Type')
end
% lab
switch cfg_dlgs.lab
    case 'M' 
        disp('MEG ok')
        % TODO: set triggers for MEG
        % In the MEG will be the old olfactometer
    case 'S'
        disp('SL ok')
        % TODO: set triggers for sleep lab
        % In the sleep lab will be the new olfactometer
    otherwise
        error('Invalid Lab')
end

end