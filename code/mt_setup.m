function dirRoot = mt_setup(user)
% ** function mt_setup(user)
% This script allows to adjust the parameters for the memory task. 
% Define the variables here before you run mt_run.m
% 
% IMPORTANT:    Do not change the order in which the variables are defined.
%               Some variables rely on each other
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

%% IMPORTANT: add your user profile in mt_loadUser
[dirRoot, dirPTB]   = mt_profile(user);

% Expermimental Details
MRI             = 0;
experimentName  = 'Sleep Connectivity';

%% ======================== IMAGE CONFIGURATION ========================= %
% 1. Image configuration: put file names without file extension
imageConfiguration = {
  {{ % imagesA 	LEARNING
  'ant',            'whale',        'ray',          	'hippopotamus',     'fly'           'crocodile';
  'wasp',           'toucan',       'raven',            'lobster',          'giraffe',      'cow';
  'starfish',       'rooster',      'praying_mantis',   'lioness',          'grasshopper',  'cat';
  'sparrow',        'pigeon',       'penguin',          'hummingbird',      'goose',        'armadillo';
  'scorpion',       'oyster',       'ostrich',          'horse',            'dromedary',    'dragonfly'
  }
  { % imagesA 	INTERFERENCE
  'goose',       	'dromedary', 	'cat',              'starfish',			'hen', 			'pigeon';
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
  'rhino',		'killer_whale',	'goose',	'kangaroo',     'tiger',		'seagull';
  'beetle',		'crab',			'pomfret',  'platypus',     'bat	'       'zebra';
  'kiwi',		'tapir',		'barn_owl', 'bee',          'partridge',    'termite';
  'dolphin',	'mussel', 		'elephant', 'hen',          'pelican',      'mosquito';
  'butterfly',	'manatee',      'ladybird', 'owl',          'cheetah',      'turtle'
  }}
};


%% =========================== IMAGE SEQUENCE =========================== %

% Define in which order cards are flipped
% 2D Table-view: Look at imagesATable or imagesBTable tables for 2D coordinates
[imagesATable, imagesBTable] = mt_imageTable(imageConfiguration);

% 2D coordinates for cards to be flipped
% imageSequence2D 	= {...
%     % Sequence for Control
%     {'E5', 'F3' , 'D4', 'F1'} ...
%     % Sequence for Learning
%     {'A1', 'B3' , 'C1'} ...
% 	% Sequence for Interference
%     {'A1', 'B3' , 'C1'} ...
%     % Sequence for Immediate Recall & Retrieval
%     {'A1', 'B3' , 'C1', 'D4'} ...
%     % Sequence for Gray Mode
%     {'A1', 'B3' , 'C1', 'D4'} ...
%     }; 

imageSequence2D = {{'A2','A3','A4','A1'}, {'A1'}, {'A1'}, {'A1'}, {'A1'}, {'A1'}};

%% ================================ TEXT ================================ %
% Text strings used during the program
textIntro = {  ...
    'Willkommen!'
    ''
    'Im Folgenden sehen Sie mehrere Karten.'
    'Unter jeder Karte befindet sich ein Bild.'
    'Merken Sie sich die Positionen der Bilder.'
    ''
    'Viel Spaß!'
    'Beliebige Taste drücken...'
    };
textPracticeLearn = { ...
    'Demonstration:'
    ''
    'Lernen:'
    '  Zwei Karten werden aufgedeckt.'
    '  Merken Sie sich die Position der Bilder'
    'Beliebige Taste drücken...'
    };
textPracticeRecall = { ...
    'Demonstration:'
    ''
    'Abfrage:'
    '  Klicken Sie auf die Karte'
    '  unter der sich das Bild befindet'
    'Beliebige Taste drücken...'
    };
textOutro = {  ...
    'Ende';
    '';
    'Danke für die Teilnahme!';
    'Auf Wiedersehen!';
    'Beliebige Taste drücken...'
    };
textSession = {
    'Konzentration';    % Control    
    'Lernen';           % Learning
    'Abfrage';          % Interference
    'Abfrage';          % Recall
    'Konzentration';    % Gray Mode
    };

% Text Properties
textDefSize     = 35;           % default Text Size
textDefFont     = 'Georgia';    % default Text Font
textDefColor    = [0 0 0];      % default Text Color
textSx          = 'center';     % default Text x-position
textSy          = 5;            % default Text y-position
textVSpacing    = 2;            % default Text vertical line spacing


%% =========================== IMAGE FOLDERS ============================ %
% Card images
imageFolder       = {'imagesA', 'imagesB', 'imagesPractice'};
imageFileExt      = '.jpg';		% image file types

% Feedback images
feedbackFolder    = 'imagesFeedback';
imagesFeedback    = {'correct.png', 'incorrect.png', 'nofeedback.png'};
feedbackMargin    = 10;       	% #pixels the images are smaller than the cards


%% ========================== CARD PROPERTIES =========================== %
% Number of cards
ncards_x            = 6;
ncards_y            = 5;

% Top Card Properties
topCardHeigth       = 200;          % Size of the top Card
topCardColor        = [1; 1; 1];    % Color of the top Card

% Memory Cards
cardColors          = [.5; .5; .5]; % Color of cards
margin              = 5;            % Margin between cards
frameWidth          = 2;            % Frame/border around cards
frameColor          = 0;            % Frame color

% Control Task Card Properties
cardColorControl        = 0.3;          % color of highlighted card
textColorCorrect        = [0.2 1 0.2];  % text color for correct response
textColorIncorrect      = [1 0.2 0.2];  % text color for incorrect response
controlTextMargin       = 200;          % distance in x from text to card
controlFeedbackDisplay  = 3;            % feedback display duration

try
    controlList             = load(fullfile(dirRoot, 'controlList.mat'));
catch
    fprintf('Control Lists missing: run mt_controlList.m')
    error(ME.message)
end

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
topCardDisplay      = 2.5;    	% Duartion top Card is shown (seconds)
cardDisplay         = 2.5;     	% Duration memory cards are shown (seconds)
feedbackDisplay     = 1;        % Duration feedback is shown (seconds)
if MRI
    responseTime     = 5;
else
    responseTime     = 10;
end


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

% Size of Memory Cards
topCardWidth        = topCardHeigth * (4/3);
cardHeigth          = round((windowSize(2)-topCardHeigth)/ncards_y);
cardWidth           = round(windowSize(1)/ncards_x);
cardSize            = [0 0 cardWidth cardHeigth]; % size to fill screen
cardSize(3:4)       = cardSize(end-1:end)-margin;
ncards              = ncards_x * ncards_y;

% Size of images hidden under the cards
imagesSize          = [0 0 cardHeigth*(4/3) cardHeigth]; % assure 4:3
imagesSize(3:4)     = imagesSize(3:4)-margin;

% Generate file names of images
imageFilesA         = {
    cellfun(@(x) strcat(x,imageFileExt), imageConfiguration{1}{1}, 'UniformOutput', false)
    cellfun(@(x) strcat(x,imageFileExt), imageConfiguration{1}{2}, 'UniformOutput', false)
    };
imageFilesB         = {
    cellfun(@(x) strcat(x,imageFileExt), imageConfiguration{2}{1}, 'UniformOutput', false)
    cellfun(@(x) strcat(x,imageFileExt), imageConfiguration{2}{2}, 'UniformOutput', false)
    };

% Practice set settings
imageFilesP             = {'teapot.jpg', 'guitar.jpg'};
imageSequencePractice   = [10, 26];
imgfolderP              = fullfile(dirRoot, imageFolder{3});


% Transform intuitive 2D coordinates into 1D coordinates used for iteration
cardSequence        = cell(size(imageSequence2D));
for r = 1: size(cardSequence, 2)
    cardSequence{r} = cellfun(@(x) mt_cards2Dto1D(x, ncards_x, ncards_y), imageSequence2D{r});
end

% Folder for configurations
setupdir            = fullfile(dirRoot, 'setup');
if ~exist(setupdir, 'dir')
    mkdir(setupdir) % create folder in first run
end

% Save configuration in workdir
cd(dirRoot)
save(fullfile(setupdir, 'mt_params.mat'))
end