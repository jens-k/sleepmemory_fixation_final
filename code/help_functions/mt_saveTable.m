function mt_saveTable(dirRoot, performance)
% ** function mt_saveTable(performance)
%
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Load parameters specified in mt_setup.m
load(fullfile(dirRoot,'setup','mt_params.mat'))   % load workspace information and properties

% Contruct output table
nRuns = length(performance.correct);

% Constant variables
sessionTime         = {datestr(now, 'HH:MM:SS')};
sessionDate         = {datestr(now, 'yy/mm/dd')};
Lab                 = {cfg_cases.lab{cfg_dlgs.lab}};
ExperimentName      = {cfg_dlgs.experimentName};
Subject             = {cfg_dlgs.subject};
Session             = {cfg_cases.sesstype{cfg_dlgs.sesstype}};
MemoryVersion       = {cfg_cases.memvers{cfg_dlgs.memvers}};
Accuracy            = {sum(performance.correct) / nRuns};

tableLeft   = table(sessionTime, sessionDate, Lab, ExperimentName, Subject, Session, ...
    MemoryVersion, Accuracy);
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
% ODOR ON?

% Learning list
% cardSequenceLearning = imageNames(cardSequence{cfg_dlgs.sesstype});

% ODOR TRIGGER
% cfg_dlgs.lab


fName = fullfile(dirRoot, subdir, ['mtp_sub_' cfg_dlgs.subject '_night_' cfg_dlgs.night '.mat']);
% save performance of subject for each run with recall 
if exist(fName, 'file')
    tableOld = load(fName);
    tableOld = tableOld.subjectData;
else
    tableOld = table();
end
subjectData = [tableOld; tableSave];

% save performance of subject for each run with recall 
save(fName, 'subjectData')

end