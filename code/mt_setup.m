%%
% Do not change the order since some variables rely on each other

%% System variables
filesep             = '/';
% win               = % define which display window is used
%% Folders: provide the full paths
% root
workdir             = 'D:\Studium Tübingen\Master Thesis\00 - Program\';
% picture folder
imgfolderA           = [workdir filesep 'picturesA'];
imgfolderB           = [workdir filesep 'picturesB'];

%% Displays
% define which window size is used as reference to display the cards
windowSize          = [1024 768];

%% Cards
% Specify number of cards
ncards_x            = 6;
ncards_y            = 5;
ncards              = ncards_x * ncards_y;

% Card properties
% topCard
topCardHeigth       = 200;
topCardWidth        = topCardHeigth * (4/3);
topCardColor        = [1; 1; 1];
% display duration of cards
topCardDisplay      = 2.5; % in seconds

% cards
% margin between cards
margin              = 5;
% size of cards
cardHeigth          = round((windowSize(2)-topCardHeigth)/ncards_y);
cardWidth           = round(windowSize(1)/ncards_x);
cardSize            = [0 0 cardWidth-margin cardHeigth-margin]; % size to fill screen
% color of cards
cardColors          = [0.5; 0.5; 0.5];
% display duration of cards
cardDisplay         = 2.5; % in seconds
% Images hidden under cards
imagesSize          = [0 0 cardHeigth*(4/3)-margin cardHeigth-margin]; % assure 4:3

% Define in which order cards are flipped
% cardSequence = linspace(1, ncards_x*ncards_y, ncards_x*ncards_y);
cardSequence   = {...
    % Sequence for Learning
    [1,10,20], ...
    % Sequence for Immediate Recall & Retrieval
    [13,21,11] ...
    }; 

%% save setup
addpath(workdir)
save('mt_params.mat')