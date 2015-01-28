function rootdir = mt_setup(user)
% ** function mt_setup(user)
% This script allows to adjust the parameters for the memory task. 
% Define the variables here before you run mt_run.m :
%
%   Folders
%       workdir:    contains the code (mt_XX.m) and the images (imgfolderX)
%       PTBdir:     Psychtoolbox installation path
%       imgfolderA: images shown in learning and recall sessions
%       imgfolderB: images shown in interference session
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
% rootdir           char        path to root working directory
%
% 
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Pre-defined users
if user
    % add your user profile in mt_loadUser
    [rootdir, PTBdir]   = mt_loadUser(user);
else
    % Root folder
    rootdir             = '';
    % Psychtoolbox installation folder
    PTBdir              = '';
end
%% Set general variables
% Optional: define which display window is used (put a number)
% By default external screens are automatically used if connected 
% win               = ;

%% Set Folders: provide the full paths

% Folder for configurations
setupdir            = fullfile(rootdir, 'setup');
if ~exist(setupdir, 'dir')
    mkdir(setupdir) % create folder in first run
end
% Picture folder: A = Learning, B = Interference
imgfolderA        	= fullfile(rootdir, 'picturesA');
imgfolderB      	= fullfile(rootdir, 'picturesB');

%% Set Display properties
% Define which window size is used as reference to display the cards
windowSize          = [1024 768];
screenBgColor       = [1 1 1]; % white background
textBgColor         = [1 1 1]; % white background
CursorType          = 'Arrow';

%% Set Card properties
% Specify number of cards
ncards_x            = 6;
ncards_y            = 5;
ncards              = ncards_x * ncards_y;

% Card properties
% Size of the top Card
topCardHeigth       = 200;
topCardWidth        = topCardHeigth * (4/3);
topCardColor        = [1; 1; 1];
% Display duration of the top Card
topCardDisplay      = 2.5; % in seconds

% Cards
% Margin between cards
margin              = 5;
% Frame/border around cards
frameWidth          = 2;
frameColor          = 0; % black
% Size of cards
cardHeigth          = round((windowSize(2)-topCardHeigth)/ncards_y);
cardWidth           = round(windowSize(1)/ncards_x);
cardSize            = [0 0 cardWidth cardHeigth]; % size to fill screen
cardSize(3:4)       = cardSize(end-1:end)-margin;
% Color of cards
cardColors          = [0.5; 0.5; 0.5];
% Duration the cards are displayed
cardDisplay         = 2.5; % in seconds

%% Feedback images: tick and cross
imgfolderFeedback       = fullfile(rootdir, 'picturesFeedback');
[imgCorrect, ~, alpha]  = imread(fullfile(imgfolderFeedback, 'correct.png'));
imgCorrect(:,:,4)       = alpha;
[imgIncorrect, ~, alpha]= imread(fullfile(imgfolderFeedback, 'incorrect.png'));
imgIncorrect(:,:,4)     = alpha;
[imgNoFeedback, ~, alpha] = imread(fullfile(imgfolderFeedback, 'nofeedback.png'));
imgNoFeedback(:,:,4)      = alpha;
feedbackOn              = 1; % if set to 0 a blue dot is shown instead of feedback 
feedbackMargin          = 10; % in pixels
feedbackDisplay         = 1; % in seconds

%% Size of images hidden under the cards
imagesSize          = [0 0 cardHeigth*(4/3) cardHeigth]; % assure 4:3
imagesSize(3:4)     = imagesSize(3:4)-margin;

%% Define image configuration
imageConfiguration = {
  % imagesA
  {
  'ant',        'whale',    'ray',              'hippopotamus', 'fly'           'crocodile';
  'wasp',       'toucan',   'raven',            'lobster',      'giraffe',      'cow';
  'starfish',   'rooster',  'praying_mantis',   'lioness',      'grasshopper',  'cat';
  'sparrow',    'pigeon',   'penguin',          'hummingbird',  'goose',        'armadillo';
  'scorpion',   'oyster',   'ostrich',          'horse',        'dromedary',    'dragonfly'
  }
  % imagesB
  {
  'barn_owl',   'tiger',    'seagull',          'owl',          'dolphin',      'cheetah';
  'zebra',      'pelican',  'shark',            'mussel',       'kiwi'          'butterfly';
  'turtle',     'ladybird', 'rhino',            'mosquito',     'tapir',        'beetle';
  'elephant',   'platypus', 'pomfret',          'manatee',      'crab',         'bee';
  'termite',   	'hen',      'kangaroo',         'killer_whale', 'duck',         'bat'
  }
};

fileExt = '.jpg';
% the matrices are transposed due iteration through cell arrays, which goes
% vertically while the pictures are printed from left to right
imageFilesA = cellfun(@(x) strcat(x,fileExt), imageConfiguration{1}, 'UniformOutput', false)';
imageFilesB = cellfun(@(x) strcat(x,fileExt), imageConfiguration{2}, 'UniformOutput', false)';


%% Define in which order cards are flipped
% cardSequence = linspace(1, ncards_x*ncards_y, ncards_x*ncards_y);
cardSequence   = {...
    % Sequence for Learning
    [1,10,20] ...
    % Sequence for Immediate Recall & Retrieval
    [13,21,11] ...
	% Sequence Interference
    [13,21,11] ...
    % Sequence Control
    [13,21,11] ...
    }; 

%% Performance variables
% cardShown | cardClicked | mousex | mousey | time

%% Text strings used during the program
defTextSize = 50;
defTextFont = 'Arial';
sx          = 'center';
sy          = 10;
vspacing    = 1.5;

sessionText = {
    'Lernen';  % Learning
    'Abfrage'; % Recall
    'Abfrage'; % Interference
    'Konzentration'; % Control
    };
introText = {  ...
    'Willkommen!';
    'Im Folgenden ....';
    'Viel Spaß!';
    'Beliebige Taste drücken...'
    };
outroText = {  ...
    'Danke für die Teilnahme';
    '....';
    'Auf Wiedersehen!';
    'Beliebige Taste drücken...'
    };
 

%% Save configuration in workdir
addpath(genpath(rootdir))
addpath(PTBdir)
cd(rootdir)
save(fullfile(setupdir, 'mt_params.mat'))
end