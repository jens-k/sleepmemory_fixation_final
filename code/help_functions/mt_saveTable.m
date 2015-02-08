function mt_saveTable(dirRoot, performance, varargs)
% ** function mt_saveTable(performance)
%
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Load parameters specified in mt_setup.m
load(fullfile(dirRoot, 'setup', 'mt_params.mat'))   % load workspace information and properties

%% Contruct output table
nRuns = length(performance.correct);
if nargin == 3 && varargs == 1
    feedbackOn	= 1;
else
    feedbackOn	= 0;
end


% Constant variables
SessionTime         = {datestr(now, 'HH:MM:SS')};
SessionDate         = {datestr(now, 'yyyy/mm/dd')};
Lab                 = cfg_cases.lab(cfg_dlgs.lab);
ExperimentName      = {experimentName};
Subject             = {cfg_dlgs.subject};
Session             = {cfg_dlgs.sessName};
Feedback            = {feedbackOn};
MemoryVersion       = cfg_cases.memvers(cfg_dlgs.memvers);
Odor                = {cfg_dlgs.odor};
Accuracy            = {100 * sum(performance.correct) / nRuns};
ControlList         = {nControlList};

tableLeft   = table(SessionTime, SessionDate, Lab, ExperimentName, Subject, Session, ...
    Feedback, MemoryVersion, Odor, Accuracy, ControlList);
tableLeft   = repmat(tableLeft, nRuns, 1);

% Changing variables
Correct             = performance.correct;
Stimulus            = performance.imageShown;
Response            = performance.imageClicked;
ReactionTime        = performance.mouseData(:, 3);
MouseX              = performance.mouseData(:, 1);
MouseY              = performance.mouseData(:, 2);
CardShownCoords     = performance.coordsShown;
CardClickedCoords   = performance.coordsClicked;

tableRight  = table(Correct, Stimulus, Response, ReactionTime, MouseX, ...
    MouseY, CardShownCoords, CardClickedCoords);

tableSave   = [tableLeft tableRight];

%% Update & Save the table that contains subject data
fName = fullfile(dirRoot, subdir, ['mtp_sub_' cfg_dlgs.subject '_night_' cfg_dlgs.night]);
% save performance of subject for each run with recall 
if exist(strcat(fName, '.mat'), 'file')
    tableOld = load(fName);
    tableOld = tableOld.subjectData;
else
    tableOld = table();
end
subjectData = [tableOld; tableSave];

% Save updated table 
save(strcat(fName, '.mat'), 'subjectData')
% Save in .csv for python analysis
writetable(subjectData, strcat(fName, '.csv'))

end