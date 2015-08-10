function mt_setupCards(dirRoot, cfg_window)
% ** function mt_setupCards(dirRoot, cfg_window)
% This function computes the coordinates for the rectangles and images
% displayed on the screen. Further it loads the image files and creates
% textures which then can be displayed using Psychtoolbox (DrawTexture)
%
% USAGE:
%       mt_setupCards(dirRoot, cfg_window);
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% dirRoot           char        path to root working directory
% cfg_window        struct      contains window information
%   .screen         1X2 double  [screens ScreenNumber]
%   .window         1X5 double  [window windowRect], actual resolution
%   .window43       1X5 double  [window windowRect], 4:3 resolution
%   .center         1X2 double  [Xcenter Ycenter]
%
%
% AUTHOR:   Marco Rüth, contact@marcorueth.com
%           Jens Klinzing, jens.klinzing@uni-tuebingen.de

%% Load parameters specified in mt_setup.m
load(fullfile(dirRoot, 'setup', 'mt_params.mat'))   % load workspace information and properties

%% Set window parameters
% Specify the display window 
window             = cfg_window.window(1);

% Specify window dimensions
screenSize      = cfg_window.window(end-1:end);
screenSize43    = windowSize;
[screenOff]     = [(screenSize(1)-screenSize43(1))/2 (screenSize(2)-screenSize43(2))/2];

% Set background color
Screen('FillRect', window, screenBgColor);

%% Create variables for the cards
% Create top card
topCard         = CenterRectOnPointd([0 0 topCardWidth topCardHeigth], screenSize43(1)/2+screenOff(1), topCardHeigth/2);
topCardDot      = CenterRectOnPointd(topCardDotSize, screenSize43(1)/2+screenOff(1), topCardHeigth/2);

% Calculate coordinates for the ncards_y X ncards_x rectangles
cardCoordsX     = linspace(1,screenSize43(1),ncards_x+1)+screenOff(1);
cardCoordsX     = round(cardCoordsX(1:end-1) + (cardCoordsX(2)-cardCoordsX(1))/2);
cardCoordsY     = linspace(topCardHeigth,screenSize43(2),ncards_y+1);
cardCoordsY     = round(cardCoordsY(1:end-1) + (cardCoordsY(2)-cardCoordsY(1))/2);
    
% The cardsAll vector stores all rectangles that cover the images
cardsAll        = zeros(ncards_y, 4, ncards_x);
for r = 1: length(cardCoordsY)
    for iCard = 1: length(cardCoordsX)
        cardsAll(r,:,iCard) = CenterRectOnPointd(cardSize, cardCoordsX(iCard), cardCoordsY(r));
    end
end

% The imagesAll vector stores all rectangles in which images are displayed
imagesAll        = zeros(ncards_y, 4, ncards_x);
for r = 1: length(cardCoordsY)
    for iCard = 1: length(cardCoordsX)
        imagesAll(r,:,iCard)    = CenterRectOnPointd(imagesSize, cardCoordsX(iCard), cardCoordsY(r));
    end
end

% The rects/imgs vectors store all rectangles in PTB format
rects           = zeros(4,ncards);
imgs            = zeros(4,ncards);
for r = 1: length(cardCoordsY)
    rects(:,(r-1)*ncards_x+1:r*ncards_x)    = reshape(cardsAll(r,:,:), 4, ncards_x);
    imgs(:,(r-1)*ncards_x+1:r*ncards_x)     = reshape(imagesAll(r,:,:), 4, ncards_x);
end

%% Read in the pictures for the cards
images	= cell(ncards, 1);
for r = 1: ncards
    isinterf = (cfg_dlgs.sesstype==3)+1;    % check if interference
    if cfg_dlgs.memvers == 1
        pic_file 	= fullfile(imgfolderA, imageFilesA{isinterf}{r});
    elseif cfg_dlgs.memvers == 2
        pic_file 	= fullfile(imgfolderB, imageFilesB{isinterf}{r});
    end
    images{r}	= imread(pic_file);
end

%% Read in the pictures for the control cards
controlImages	= cell(ncards, 1);
for r = 1: ncards
    isinterf = (cfg_dlgs.sesstype==3)+1;    % check if interference
    if cfg_dlgs.memvers == 1
        pic_file 	= fullfile(controlFolderA, imageFilesA{1}{r});
    elseif cfg_dlgs.memvers == 2
        pic_file 	= fullfile(controlFolderB, imageFilesB{1}{r});
    end
    controlImages{r}	= imread(pic_file);
end

%% Save configuration in setupdir
save(fullfile(setupdir ,'mt_params.mat'), '-append', ...
    'screenOff', 'topCard', 'topCardDot', 'rects', 'imgs', 'images', 'controlImages')

end