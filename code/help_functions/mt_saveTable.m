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
load(fullfile(dirRoot, 'setup', 'mt_params.mat'), 'cfg_dlgs', 'cfg_cases', 'experimentName', 'dirData')   % load workspace information and properties

%% Load table if already exists
fName = ['mtp_sub_' cfg_dlgs.subject '_night_' cfg_dlgs.night '_sess_' num2str(cfg_dlgs.sesstype)];
% save performance of subject for each run with recall 
if exist(fullfile(dirData, 'DATA', strcat(fName, '.mat')), 'file')
    tableOld = load(fullfile(dirData, 'DATA', strcat(fName, '.mat')));
    tableOld = tableOld.subjectData;
else
    tableOld = table();
end

%% Construct output table
nRuns = length(performance.correct);
if (nargin == 3 && varargin{1} == 1) || (nargin == 4 && varargin{1} == 1)
    feedbackOn	= 1;
else
    feedbackOn	= 0;    
end

ntrials = length(performance.SessionTime);
% Constant variables
SessionDate         = {datestr(now, 'yyyy/mm/dd')};
SessionTime         = performance.SessionTime(1);
Lab                 = cfg_cases.lab(cfg_dlgs.lab);
ExperimentName      = {experimentName};
Subject             = {cfg_dlgs.subject};
if strcmp(cfg_dlgs.sessName, 'Control')
    Session         = {cfg_dlgs.sessName};
    SessionTime         = performance.SessionTime(1);
elseif strcmp(cfg_dlgs.sessName, 'Fixation')
    Session         = {'FixationTask'};
elseif strcmp(performance.session, 'Practice')
    Session         = {'Practice'};
else
    Session         = {[cfg_dlgs.sessName '-' cfg_cases.sessNames{performance.session}]};
end
if nargin == 4 && isnumeric(varargin{2})
    Accuracy            = varargin{2};
else
    Accuracy            = 100 * mean(performance.correct);
end

Feedback            = {feedbackOn};
MemoryVersion       = cfg_cases.memvers(cfg_dlgs.memvers);
Odor                = {cfg_dlgs.odor};

tableLeft   = table(SessionDate, SessionTime, Lab, ExperimentName, Subject, Session, ...
    Feedback, MemoryVersion, Odor, Accuracy);
tableLeft   = repmat(tableLeft, nRuns, 1);

% Changing variables
TrialTime           = performance.TrialTime;
Block               = performance.run;
Correct             = performance.correct;
Stimulus            = performance.imageShown;
Response            = performance.imageClicked;
ReactionTime        = performance.mouseData(:, 3);
MouseX              = performance.mouseData(:, 1);
MouseY              = performance.mouseData(:, 2);
CardShownCoords     = performance.coordsShown;
CardClickedCoords   = performance.coordsClicked;

tableRight  = table(TrialTime, Block, Correct, Stimulus, Response, ReactionTime, MouseX, ...
    MouseY, CardShownCoords, CardClickedCoords);

tableSave   = [tableLeft tableRight];
subjectData = [tableOld; tableSave];

%% Update & Save the table that contains subject data

% Save updated table 
save(fullfile(dirData, 'DATA', strcat(fName, '.mat')), 'subjectData')

end