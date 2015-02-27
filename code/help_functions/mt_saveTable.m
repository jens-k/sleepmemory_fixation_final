function mt_saveTable(dirRoot, performance, varargin)
% ** function mt_saveTable(dirRoot, performance, varargin)
% Stores the trial or session data in a table and saves it as .csv and
% .mat file. Can be called from mt_controlTask, mt_cardGame, and
% mt_cardGamePractice.
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% dirRoot           char        path to root working directory
% performance       table       contains trial information
% varargin          cell        optional: 
%                                   1. Feedback (0 or 1) 
%                                   2. Accuracy
%
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Load parameters specified in mt_setup.m
load(fullfile(dirRoot, 'setup', 'mt_params.mat'))   % load workspace information and properties

%% Load table if already exists
fName = ['mtp_sub_' cfg_dlgs.subject '_night_' cfg_dlgs.night];
% save performance of subject for each run with recall 
if exist(fullfile(dirRoot, 'DATA', strcat(fName, '.mat')), 'file')
    tableOld = load(fullfile(dirRoot, 'DATA', strcat(fName, '.mat')));
    tableOld = tableOld.subjectData;
else
    tableOld = table();
end

%% Contruct output table
nRuns = length(performance.correct);
if (nargin == 3 && varargin{1} == 1) || (nargin == 4 && varargin{1} == 1)
    feedbackOn	= 1;
else
    feedbackOn	= 0;    
end

if nargin == 4 && isnumeric(varargin{2})
    sessLength  = length(tableOld.SessionTime(strcmp(tableOld.SessionTime, tableOld.SessionTime(end))));
    subjectData = tableOld;
    Accuracy    = cell(sessLength, 1);
    Accuracy(:)	= varargin(2);
    subjectData.Accuracy(end-sessLength+1:end) = Accuracy;
else
    % Constant variables
    SessionDate         = {datestr(now, 'yyyy/mm/dd')};
    SessionTime         = performance.SessionTime;
    TrialTime           = performance.TrialTime;
    Lab                 = cfg_cases.lab(cfg_dlgs.lab);
    ExperimentName      = {experimentName};
    Subject             = {cfg_dlgs.subject};
    if strcmp(cfg_dlgs.sessName, 'Control')
        Session         = {cfg_dlgs.sessName};
        SessionTime         = performance.SessionTime(1);
        TrialTime           = performance.TrialTime(1);
    elseif strcmp(performance.session, 'Practice')
        Session         = {'Practice'};
    else
        Session         = {[cfg_dlgs.sessName '-' cfg_cases.sessNames{performance.session}]};
    end
    Feedback            = {feedbackOn};
    MemoryVersion       = cfg_cases.memvers(cfg_dlgs.memvers);
    Odor                = {cfg_dlgs.odor};
    Accuracy            = {0};

    tableLeft   = table(SessionDate, SessionTime, TrialTime, Lab, ExperimentName, Subject, Session, ...
        Feedback, MemoryVersion, Odor, Accuracy);
    tableLeft   = repmat(tableLeft, nRuns, 1);
    tableLeft.TrialTime = performance.TrialTime;

    % Changing variables
    Block               = performance.run;
    Correct             = performance.correct;
    Stimulus            = performance.imageShown;
    Response            = performance.imageClicked;
    ReactionTime        = performance.mouseData(:, 3);
    MouseX              = performance.mouseData(:, 1);
    MouseY              = performance.mouseData(:, 2);
    CardShownCoords     = performance.coordsShown;
    CardClickedCoords   = performance.coordsClicked;

    tableRight  = table(Block, Correct, Stimulus, Response, ReactionTime, MouseX, ...
        MouseY, CardShownCoords, CardClickedCoords);

    tableSave   = [tableLeft tableRight];
    subjectData = [tableOld; tableSave];
end

%% Update & Save the table that contains subject data

% Save updated table 
save(fullfile(dirRoot, 'DATA', strcat(fName, '.mat')), 'subjectData')
% Save in .csv for python analysis
writetable(subjectData, fullfile(dirRoot, 'DATA', strcat(fName, '.csv')))

% Backup
copyfile(fullfile(dirRoot, 'DATA', [fName '.*']), fullfile(dirRoot, 'BACKUP'), 'f');


end