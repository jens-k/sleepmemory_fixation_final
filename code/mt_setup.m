function rootdir = mt_setup()
% ** mt_setup
% This script allows to adjust the parameters for the memory task. 
% Define the variables here before you run mt_run.m :
%
%   1) Unix: filesep = '\';     Windows: filesep = '/'
%   2) Folders
%       workdir:    contains the code (mt_XX.m) and the images (imgfolderX)
%       PTBdir:     Psychtoolbox installation path
%       imgfolderA: images shown in learning and recall sessions
%       imgfolderB: images shown in interference session
% 
% IMPORTANT:    Do not change the order in which the variables are defined.
%               Some variables rely on each other
%
% 
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Set System variables
filesep             = '/';
% Optional: define which display window is used (put a number)
% By default external screens are automatically used if connected 
% win               = ;

%% Set Folders: provide the full paths
% Root folder
rootdir             = 'D:\Master Thesis\00 - Program\';
% Psychtoolbox installation folder
PTBdir              = 'D:\AnalysisSoftware\PTB\Psychtoolbox\';
% Picture folder: A = Learning, B = Interference
imgfolderA           = [rootdir filesep 'picturesA'];
imgfolderB           = [rootdir filesep 'picturesB'];

%% Set Display properties
% Define which window size is used as reference to display the cards
windowSize          = [1024 768];
screenBgColor       = [1 1 1]; % white background
introBgColor        = [1 1 1]; % white background
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
frameWidth          = 3;
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
imgfolderFeedback       = [rootdir filesep 'picturesFeedback'];
[imgCorrect, ~, alpha]  = imread(fullfile(imgfolderFeedback, 'correct.png'));
imgCorrect(:,:,4)       = alpha;
[imgIncorrect, ~, alpha]= imread(fullfile(imgfolderFeedback, 'incorrect.png'));
imgIncorrect(:,:,4)     = alpha;
[imgNoFeedback, ~, alpha] = imread(fullfile(imgfolderFeedback, 'nofeedback.png'));
imgNoFeedback(:,:,4)      = alpha;
nofeedback              = 0; % if set to 1 blue dot is shown instead of feedback 
feedbackMargin          = 10; % in pixels
feedbackDisplay         = 1; % in seconds

%% Size of images hidden under the cards
imagesSize          = [0 0 cardHeigth*(4/3) cardHeigth]; % assure 4:3
imagesSize(3:4)     = imagesSize(3:4)-margin;

% %% Define image configuration
% imageConfiguration = {
%   '' 
% };

%% Define in which order cards are flipped
% cardSequence = linspace(1, ncards_x*ncards_y, ncards_x*ncards_y);
cardSequence   = {...
    % Sequence for Learning
    [1,10,20] ...
    % Sequence for Immediate Recall & Retrieval
    [13,21,11] ...
	% Sequence Interference
    [13,21,11] ...
    }; 

%% Performance variables
% cardShown | cardClicked | mousex | mousey | time

%% Text strings used during the program
textSize    = 50;
textFont    = 'Arial';
sx          = 'center';
sy          = 10;
vspacing    = 1.5;

introText = {  ...
    'Willkommen zum Experiment';
    'Sie müssen nun ....';
    'Viel Spaß!';
    'Beliebige Taste drücken...'
    };
sessionText = {
    'Lernen';  % Learning
    'Abfrage'; % Recall
    'Abfrage'; % Interference
    };
 

%% Save configuration in workdir
addpath(rootdir)
cd(rootdir)
save(fullfile(rootdir,'code','mt_params.mat'))
end