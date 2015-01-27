function performance = mt_cards(rootdir, cfg_window)
% ** function mt_cards(cfg_window)
% This function creates the cards, adds them to the buffer and displays the
% card matrix on the screen. Further, the memory task is initiated based 
% on the session type defined in the input dialogues
%
% USAGE:
%     mt_cards(cfg_window)
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% cfg_window        struct      contains window information
%   .screen         1X2 double  [screens ScreenNumber]
%   .window         1X5 double  [window windowRect], actual resolution
%   .window43       1X5 double  [window windowRect], 4:3 resolution
%   .center         1X2 double  [Xcenter Ycenter]
%
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Load parameters specified in mt_setup.m
load(fullfile(rootdir,'code','mt_params.mat'))   % load workspace information and properties

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
for r = 1: length(cardCoordsY)
    rects(:,(r-1)*ncards_x+1:r*ncards_x)    = reshape(cardsAll(r,:,:), 4, ncards_x);
    imgs(:,(r-1)*ncards_x+1:r*ncards_x)     = reshape(imagesAll(r,:,:), 4, ncards_x);
end

%% Read in the pictures for the cards
for r = 1: length(rects)
    if cfg_dlgs.memvers == 1
        pic_file 	= [imgfolderA filesep mt_getFilenames(imgfolderA, r, 1)];
    elseif cfg_dlgs.memvers == 2
        pic_file 	= [imgfolderB filesep mt_getFilenames(imgfolderB, r, 1)];
    end
    pic      	= imread(pic_file);
    % TODO: create a ncards_x X ncards_y table with picture names?
    % for better overview define the image matrix in mt_setup
    images(r)   = Screen('MakeTexture', window, pic);
end

%% Show which session is upcoming
mt_showText(sessionText{cfg_dlgs.sesstype}, window);
% Initialize variables for measured parameters
cardShown      = cardSequence{cfg_dlgs.sesstype}';
cardClicked    = zeros(length(cardShown), 1);
mouseData       = zeros(length(cardShown), 3);

%% Start the game
% In the learning session all pictures are shown in a sequence
% In the recall sessions mouse interaction is activated
for iCard = 1: length(cardShown)

    ShowCursor;
    imageCurrent = cardShown(iCard);
    imageTop = images(imageCurrent);
    
    % Draw the rects to the screen
    Priority(MaxPriority(window));
    Screen('FillRect', window, topCardColor, topCard);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    Priority(0);
    
    % Show a picture on top
    Priority(MaxPriority(window));
    Screen('DrawTexture', window, imageTop, [], topCard);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    Priority(0);

    % Delay flipping in case of learning for cardDelay
    if cfg_dlgs.sesstype == 1
        WaitSecs(topCardDisplay);
    end
    
    % Define which card will be flipped
    switch cfg_dlgs.sesstype
        case 1 % Learning
            % the corresponding & correct card will be flipped
            cardFlip        = imageCurrent;
        otherwise % Recall/Interfence
            % OnMouseClick: flip the card
            [cardFlip, mouseData(iCard,:)] 	= mt_cardFlip(screenOff, ncards_x, cardSize, topCardHeigth);
            cardClicked(iCard)           	= cardFlip;
            % Feedback
            if nofeedback == 1
                % show feedback on the card
                Priority(MaxPriority(window));
                Screen('DrawTexture', window, imageTop, [], topCard);
                Screen('FillRect', window, cardColors, rects);
                Screen('FrameRect', window, frameColor, rects, frameWidth);
                % Show the feedback image
                Screen('DrawTexture', window, Screen('MakeTexture', window, imgNoFeedback), ...
                    [], [imgs(1:2, cardFlip)+feedbackMargin; imgs(3:4, cardFlip)-feedbackMargin]);
                Screen('Flip', window, flipTime);
                Priority(0);
                cardFlip = 0;
                WaitSecs(feedbackDisplay);
            elseif cardFlip == imageCurrent
                % show feedback on the card
                Priority(MaxPriority(window));
                Screen('DrawTexture', window, imageTop, [], topCard);
                Screen('FillRect', window, cardColors, rects);
                Screen('FrameRect', window, frameColor, rects, frameWidth);
                % Show the feedback image
                Screen('DrawTexture', window, Screen('MakeTexture', window, imgCorrect), ...
                    [], [imgs(1:2, cardFlip)+feedbackMargin; imgs(3:4, cardFlip)-feedbackMargin]);
                Screen('Flip', window, flipTime);
                Priority(0);
                WaitSecs(feedbackDisplay);
            else
                % show feedback on the card
                Priority(MaxPriority(window));
                Screen('DrawTexture', window, imageTop, [], topCard);
                Screen('FillRect', window, cardColors, rects);
                Screen('FrameRect', window, frameColor, rects, frameWidth);
                imgs(:, cardFlip)
                % Show the feedback image
                Screen('DrawTexture', window, Screen('MakeTexture', window, imgIncorrect), ...
                    [], [imgs(1:2, cardFlip)+feedbackMargin; imgs(3:4, cardFlip)-feedbackMargin]);
                Screen('Flip', window, flipTime);
                Priority(0);
                WaitSecs(feedbackDisplay);
                % Flip the correct image afterwards
                cardFlip = imageCurrent;
            end
    end

    
        % Flip the card
        Priority(MaxPriority(window));
        Screen('DrawTexture', window, imageTop, [], topCard);

        % Fill all rects but the flipped one
        if cardFlip
            Screen('FillRect', window, cardColors, rects(:, (1:ncards ~= cardFlip)));
            Screen('DrawTexture', window, images(cardFlip), [], imgs(:, cardFlip));
        else
            % no cardFlip in last recall session
            Screen('FillRect', window, cardColors, rects);
        end
        Screen('FrameRect', window, frameColor, rects, frameWidth);
        Screen('Flip', window, flipTime);
        Priority(0);

    
    % Display the card for a time defined by cardDisplay
    WaitSecs(cardDisplay);
end

%% performance
correct             = (cardShown - cardClicked) + 1;
correct(correct~=1) = 0;
performance         = table(correct, cardShown, cardClicked, mouseData);
p_correct           = sum(performance.correct)/length(performance.cardShown);
save(fullfile(rootdir,['mt_performance_sub_' cfg_dlgs.subject '.mat']), 'performance', 'p_correct')

end