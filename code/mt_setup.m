function dirRoot = mt_setup(user)
% ** function mt_setup(user) 
% This script allows to adjust the most important parameters for the memory
% task. Define the variables here before you run mt_run.m.
% 
% IMPORTANT:    Do not change the order in which the variables are defined.
%               Some variables have mutual dependencies.
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% user              char       	pre-defined user name (see mt_loadUser.m)
%
% <<< OUTPUT VARIABLES <<<
% NAME              TYPE        DESCRIPTION
% dirRoot           char        path to root working directory
%
% 
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% ============================== BASICS ================================ %
% IMPORTANT: add your user profile in mt_loadUser
[dirRoot, dirPTB]   = mt_profile(user);

% Expermimental Details
% TODO: Warum steht da "...for learning/feedback"?
MRI             = false; % set true for use in MRI scanner
experimentName  = 'Sleep Connectivity'; % name of your study
nLearningSess   = 2; % number of runs for learning
nMinRecall      = 2; % as minimum for learning/feedback 
nMaxRecall      = 5; % maximum runs for immediate recall (to exclude if too poor performance)
nFinalRecall    = 2; % number of runs for final recall (incl. one last session w/o feedback)


%% ======================== IMAGE CONFIGURATION ========================= %

% Use file names without file extension
imageConfiguration = {
  {{ % imagesA 	LEARNING
  'ant',            'whale',        'ray',          	'hippopotamus',     'fly'           'crocodile';
  'wasp',           'toucan',       'raven',            'lobster',          'giraffe',      'cow';
  'starfish',       'rooster',      'praying_mantis',   'lioness',          'grasshopper',  'cat';
  'sparrow',        'pigeon',       'penguin',          'hummingbird',      'goose',        'armadillo';
  'scorpion',       'oyster',       'ostrich',          'horse',            'dromedary',    'dragonfly'
  }
  { % imagesA 	INTERFERENCE
  'goose',       	'dromedary', 	'cat',              'starfish',			'rooster', 		'pigeon';
  'sparrow',      	'dragonfly',   	'armadillo',        'ostrich',      	'horse',    	'penguin';
  'grasshopper',	'whale',  		'scorpion',         'ray',      		'ant',  		'oyster';
  'hippopotamus', 	'wasp',   		'cow',              'praying_mantis',	'crocodile',	'raven';
  'lioness',		'fly',   		'lobster',          'giraffe',        	'hummingbird',  'toucan'
  }}
  {{ % imagesB 	LEARNING
  'barn_owl',   'tiger',        'seagull',	'owl',          'partridge',    'cheetah';
  'zebra',      'pelican',      'dolphin',	'mussel',       'kiwi'          'butterfly';
  'turtle',     'ladybird',     'rhino',	'mosquito',     'tapir',        'beetle';
  'elephant',   'platypus',     'pomfret',	'manatee',      'crab',         'bee';
  'termite',   	'hen',          'kangaroo',	'killer_whale', 'duck',         'bat'
  }
  { % imagesB 	INTERFERENCE
  'rhino',		'killer_whale',	'duck',     'kangaroo',     'tiger',		'seagull';
  'beetle',		'crab',			'pomfret',  'platypus',     'bat'           'zebra';
  'kiwi',		'tapir',		'barn_owl', 'bee',          'partridge',    'termite';
  'dolphin',	'mussel', 		'elephant', 'hen',          'pelican',      'mosquito';
  'butterfly',	'manatee',      'ladybird', 'owl',          'cheetah',      'turtle'
  }}
};


%% =========================== IMAGE SEQUENCE =========================== %

% Define in which order cards are flipped
% Special feature for you: 2D Table-view
% You can run the section 'IMAGE CONFIGURATION' above and then look at the
% tables 'imagesATable' and 'imagesBTable' for 2D coordinates below
[imagesATable, imagesBTable] = mt_imageTable(imageConfiguration);

% TODO: Add variables for main immediate recall, interference learning,
% interference immediate recall, learning final recall. Die identischen
% Reihenfolgen dürfen ruhig einfach Verweise auf die bestehenden
% Reihenfolgen sein. Außerdem sollte ein check rein, der eine Warnung
% wirft, wenn nicht alle Bilder verwendet wurden oder wenn Bilder innerhalb
% einer Sequenz doppelt verwendet wurden.

% Create sequence for learning and interference
imageSequenceLearningA = {
    'starfish', 'pigeon', 'raven', 'hummingbird'
    };

imageSequenceLearningB = {
    'beetle', 'mussel', 'hen', 'ladybird'
    };

% Convert sequences for further processing
imageSequenceLearningCoordsA = zeros(1, size(imageSequenceLearningA, 2));
imageSequenceInterferenceCoordsA = zeros(1, size(imageSequenceLearningA, 2));
imageSequenceLearningCoordsB = zeros(1, size(imageSequenceLearningB, 2));
imageSequenceInterferenceCoordsB = zeros(1, size(imageSequenceLearningB, 2));
for i = 1: size(imageSequenceLearningA, 2)
    imageSequenceLearningCoordsA(i)     = find(cellfun(@(x) strcmp(x, imageSequenceLearningA{i}), imageConfiguration{1}{1}'));
    imageSequenceInterferenceCoordsA(i) = find(cellfun(@(x) strcmp(x, imageSequenceLearningA{i}), imageConfiguration{1}{2}'));
    imageSequenceLearningCoordsB(i)     = find(cellfun(@(x) strcmp(x, imageSequenceLearningB{i}), imageConfiguration{2}{1}'));
    imageSequenceInterferenceCoordsB(i) = find(cellfun(@(x) strcmp(x, imageSequenceLearningB{i}), imageConfiguration{2}{2}'));
end

% Load sequence for controlList
try
    controlSequence = load(fullfile(dirRoot, 'code/help_functions/controlSequence.mat'));
    controlList     = controlSequence.controlList;
    controlSequence = controlSequence.controlSequence;
catch
    fprintf('Control Lists missing: run mt_controlList.m\n')
    error(ME.message)
end

% 2D coordinates for cards to be flipped
cardSequence 	= {...
    { % VERSION A
    % Sequence for Control
    controlSequence; % identical across subjects
    % Sequence for Learning
    imageSequenceLearningCoordsA; ...
    % Sequence for Interference
    imageSequenceInterferenceCoordsA; ...
    % Sequence for Immediate Recall & Retrieval
    imageSequenceLearningCoordsA; ...
    % Sequence for Gray Mode
    controlSequence ...
    }
    { % VERSION B
    % Sequence for Control
    controlSequence; % identical across subjects
    % Sequence for Learning
    imageSequenceLearningCoordsB; ...
    % Sequence for Interference
    imageSequenceInterferenceCoordsB; ...
    % Sequence for Immediate Recall & Retrieval
    imageSequenceLearningCoordsB; ...
    % Sequence for Gray Mode
    controlSequence ...
    }
}; 


%% ================================ TEXT ================================ %
% Text strings used during the program
textControl = {  ...
    'Zählaufgabe'
    ''
    'Im Folgenden sehen Sie mehrere Karten.'
    'Die Karten werden nacheinander dunkler.'
    ''
    'Ihre Aufgabe: Zählen Sie, wie viele Karten dunkler werden.'
    'Schauen Sie dabei auf das Kreuz in der Kartenmitte.'
    ''
    'Viel Spaß!'
    };
textFixation = {  ...
    'Fixation'
    ''
    'Es erscheint nun ein Kreuz in der Mitte'
    'des Bildschirms. Bitte schauen Sie auf dieses'
    'Kreuz, solange es angezeigt wird.'
    ''
    'Dies wird etwa 6 Minuten dauern.'
    };
textLearning = {  ...
    'Willkommen!'
    ''
    'Im Folgenden sehen Sie ein Feld voller verdeckter Karten.'
    'Unter jeder Karte befindet sich ein Bild.'
    ''
    'Jedes Bild wird zunächst oben angezeigt.'
    'Dann wird darunter die dazu passende Karte aufgedeckt.'
    ''
    'Ihre Aufgabe: '
    'Fixieren Sie die jeweils aufgedeckte Karte und merken '
    'Sie sich ihre Position.'
    };
textPracticeLearn = { ...
    'Zunächst ein Übungsdurchgang!'
    ''
    'Teil 1 - Lernen:'
    ''
    'Fixieren Sie die jeweils aufgedeckte Karte und merken'
    'Sie sich ihre Position.'
    };
textPracticeRecall = { ...
    'Übungsdurchgang'
    ''
    'Teil 2 - Abfrage:'
    ''
    'Oben erscheint wieder jeweils ein Bild.'
    'Fixieren Sie darunter bitte das Kreuz auf der'
    'verdeckten Karte, unter der Sie dieses Bild vermuten.'
    ''
    'Sobald die Kreuze verschwinden, '
    'klicken Sie bitte auf diese Karte.'
    };
textLearning2 = {  ...
    'Lernen'
    ''
    'Jetzt geht es wirklich los!'
    ''
    'Es werden nun alle 30 Bilder zwei Mal aufgedeckt.'
    'Danach folgt eine Abfrage der Positionen.'
    ''
    'Ihre Aufgabe: '
    'Fixieren Sie die jeweils aufgedeckte Karte und merken '
    'Sie sich ihre Position.'
    };
textRecall = { ...
    'Teil 2 - Abfrage:'
    'Oben erscheint ein Bild. Fixieren Sie das Kreuz auf der'
    'verdeckten Karte unter der Sie die das Bild vermuten.'
    ''
    'Sobald die Kreuze verschwinden, klicken Sie bitte auf die Karte.'
    ''
    };

% TODO: Diese beiden Feedback-Texte sollten noch eingebaut werden. Sollte
% das zu viel Code overhead machen, diesen Text hier zu bestimmten, darf er
% auch ruhig woanders, wo die Performance bereits bekannt ist, hard-gecoded sein.
textRecallAgain = { ...
    ''
    'Sie hatten XXX Prozent richtig.'
    ''
    'Die Abfrage wird wiederholt.'
    ''
    };
textRecallDone = { ...
    ''
    'Glückwunsch!'
    ''
    'Sie hatten XXX Prozent richtig.'
    'Jetzt nur noch ein Durchlauf!'
    ''
    };

textRecallNoFeedback = { ...
    'Die Abfrage wird noch einmal wiederholt. Diesmal wird Ihnen nicht'
    'mehr angezeigt, ob Sie richtig gelegen haben.'
    ''
    'Es erscheint lediglich ein blauer Punkt auf der'
    'geklickten Karte.'
    };
textOutro = {  ...
    'Ende'
    ''
    'Vielen Dank!'
    ''
    };
textQuestion = {  ...
    ''
    ''
    'Haben Sie noch Fragen zum Ablauf?'
    };
textSession = {
    'Konzentration'    % Control    
    'Lernen'           % Learning
    'Lernen'           % Interference
    'Abfrage'          % Recall
    'Konzentration'    % Gray Mode
    };

% Text Properties
textDefSize     = 26;           % default Text Size
textDefFont     = 'Arial';    % default Text Font
textDefColor    = [0 0 0];      % default Text Color
textSx          = 'center';     % default Text x-position
textSy          = 10;            % default Text y-position
textVSpacing    = 2;            % default Text vertical line spacing


%% =========================== IMAGE FOLDERS ============================ %
% Card images
imageFolder       = {'imagesA', 'imagesB', 'imagesPractice'};
imageFileExt      = '.jpg';		% image file types

% Feedback images
feedbackFolder    = 'imagesFeedback';
imagesFeedback    = {'correct.png', 'incorrect.png', 'nofeedback.png', 'cross.png'};
feedbackMargin    = 10;       	% #pixels the images are smaller than the cards


%% ========================== CARD PROPERTIES =========================== %
% Number of cards
ncards_x            = 6;
ncards_y            = 5;

% Top Card Properties
topCardHeigth       = 200;          % Size of the top Card
topCardColor        = [.9; .9; .9];    % Color of the top Card

% Memory Cards
cardColors          = [.5; .5; .5]; % Color of cards
cardMargin          = 5;            % Margin between cards
frameWidth          = 2;            % Frame/border around cards
frameColor          = 0;            % Frame color

% Control Task Card Properties
cardColorControl        = 0.3;          % color of highlighted card
textColorCorrect        = [0.2 1 0.2];  % text color for correct response
textColorIncorrect      = [1 0.2 0.2];  % text color for incorrect response
controlTextMargin       = 200;          % distance in x from text to card
controlFeedbackDisplay  = 3;            % feedback display duration

crossSize               = [0 0 30 30];
circleSize              = [0 0 50 50];                  


%% ============================== OPTIONAL ============================== %
% Change Cursor Type
CursorType          = 'Arrow';

% Set Display properties
% Define which window size is used as reference to display the cards
windowSize          = [1024 768];
screenBgColor       = [1 1 1]; % white background
textBgColor         = [1 1 1]; % white background

% Define which display window is used (put a number)
% Note: by default external screens are automatically used if connected 
% window              = ;

% Set Timing
topCardDisplay      = 1;    	% Duartion top Card is shown (seconds)
cardDisplay         = 5;     	% Duration memory cards are shown (seconds)
cardCrossDisplay    = 5;        % TODO: Add description.
cardRecallDisplay   = 1;     	% Duration memory cards are shown (seconds)
feedbackDisplay     = 1;        % Duration feedback is shown (seconds)
if MRI
    responseTime     = 10;       % Duration allowed to respond (click) in MRI
else
    responseTime     = 15;      % Duration allowed to respond (click) in MEG
end
fixationCrossDisplay = 7.5;     % TODO: Is this for the control task?


%% ======================= DO NOT CHANGE FROM HERE ====================== %
% Unless you know what you are doing...
% !!!!! Changes need further adjustments in other files and scripts !!!!! %

% Changing the accepted cases also requires to change mt_dialogues.m
cfg_cases.subjects  = 0:1000;                       % 0 is debug
cfg_cases.nights    = {'1', '2'};                   % Night 1 or 2
cfg_cases.memvers   = {'A', 'B'};                   % Memory version
cfg_cases.sesstype  = {'C', 'L', 'I', 'R', 'G'};    % Session Type
cfg_cases.lab       = {'MEG', 'SL3', 'SL4'};        % Lab/Location
cfg_cases.odor      = {'0', '1'}; 

% image folder
imgfolderA        	= fullfile(dirRoot, imageFolder{1});
imgfolderB      	= fullfile(dirRoot, imageFolder{2});

% Read in feedback images
imgfolderFeedback           = fullfile(dirRoot, feedbackFolder);
[imgCorrect, ~, alpha]      = imread(fullfile(imgfolderFeedback, imagesFeedback{1}));
imgCorrect(:,:,4)           = alpha;
[imgIncorrect, ~, alpha]    = imread(fullfile(imgfolderFeedback, imagesFeedback{2}));
imgIncorrect(:,:,4)         = alpha;
[imgNoFeedback, ~, alpha]   = imread(fullfile(imgfolderFeedback, imagesFeedback{3}));
imgNoFeedback(:,:,4)        = alpha;
[imgCross, ~, alpha]        = imread(fullfile(imgfolderFeedback, imagesFeedback{4}));
imgCross(:,:,4)             = alpha;


% Size of Memory Cards
topCardWidth        = topCardHeigth * (4/3);
cardHeigth          = round((windowSize(2)-topCardHeigth)/ncards_y);
cardWidth           = round(windowSize(1)/ncards_x);
cardSize            = [0 0 cardWidth cardHeigth]; % size to fill screen
cardSize(3:4)       = cardSize(end-1:end)-cardMargin;
ncards              = ncards_x * ncards_y;

% Size of images hidden under the cards
imagesSize          = [0 0 cardHeigth*(4/3) cardHeigth]; % assure 4:3
imagesSize(3:4)     = imagesSize(3:4)-cardMargin;

% Generate file names of images
imageFilesA         = {
    cellfun(@(x) strcat(x, imageFileExt), imageConfiguration{1}{1}', 'UniformOutput', false)
    cellfun(@(x) strcat(x, imageFileExt), imageConfiguration{1}{2}', 'UniformOutput', false)
    };
imageFilesB         = {
    cellfun(@(x) strcat(x, imageFileExt), imageConfiguration{2}{1}', 'UniformOutput', false)
    cellfun(@(x) strcat(x, imageFileExt), imageConfiguration{2}{2}', 'UniformOutput', false)
    };

% Practice set settings
imageFilesP             = {'teapot.jpg', 'guitar.jpg'};
imageSequencePractice   = [10, 26];
imgfolderP              = fullfile(dirRoot, imageFolder{3});


% % Transform intuitive 2D coordinates into 1D coordinates used for iteration
% cardSequence        = cell(size(imageSequence2D));
% for r = 1: size(cardSequence, 2)
%     cardSequence{r} = cellfun(@(x) mt_cards2Dto1D(x, ncards_x, ncards_y), imageSequence2D{r});
% end

% Folder for configurations
setupdir            = fullfile(dirRoot, 'setup');
if ~exist(setupdir, 'dir')
    mkdir(setupdir) % create folder in first run
end

% Folder for data
if ~exist(fullfile(dirRoot, 'DATA'), 'dir')
    mkdir(fullfile(dirRoot, 'DATA')) % create folder in first run
    mkdir(fullfile(dirRoot, 'BACKUP'))
end

% Save configuration in workdir
cd(dirRoot)
save(fullfile(setupdir, 'mt_params.mat'))
end