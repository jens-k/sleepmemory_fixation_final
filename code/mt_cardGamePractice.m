function mt_cardGamePractice(dirRoot, cfg_window)
% ** function mt_cardGame(dirRoot, cfg_window, iRecall)
% This function starts the practice session of the memory task.
% By default two cards are learned and then tested.
%
% USAGE:
%     mt_cardGamePractice(dirRoot, cfg_window)
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
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Load parameters specified in mt_setup.m
load(fullfile(dirRoot, 'setup', 'mt_params.mat'))   % load workspace information and properties

%% Set window parameters
% Specify the display window 
window      	= cfg_window.window(1);

%% Initialize variables for measured parameters
cardShown     	= imageSequencePractice';
cardClicked  	= zeros(length(cardShown), 1);
mouseData    	= zeros(length(cardShown), 3);

% Practice set
for i = 1: length(imageFilesP)
    pic_file = fullfile(imgfolderP, imageFilesP{i});
    images{imageSequencePractice(i)}	= imread(pic_file);
    pic_file = fullfile(imgfolderP, 'top', imageFilesP{i});
    imagesTop{imageSequencePractice(i)}	= imread(pic_file);
end

feedbackOn      = 1;

mt_showText(dirRoot, textPracticeLearn, window);

%% In the practice learning session all pictures are shown in a sequence
HideCursor;
% Get Session Time
SessionTime         = {datestr(now, 'HH:MM:SS')};
for iCard = 1: length(cardShown)
    
    % Get current picture
    imageCurrent    = cardShown(iCard);
    imageTop        = Screen('MakeTexture', window, imagesTop{imageCurrent});
    
    % Show a picture on top
%    Priority(MaxPriority(window)); 
    Screen('DrawTexture', window, imageTop, [], topCard);
    Screen('FrameRect', window, frameColor, topCard, frameWidth);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    Priority(0);
    WaitSecs(topCardDisplay);

    % Flip the card
%    Priority(MaxPriority(window)); 
    Screen('DrawTexture', window, imageTop, [], topCard);
    Screen('FrameRect', window, frameColor, topCard, frameWidth);

    % Fill all rects but the flipped one
    Screen('FillRect', window, cardColors, rects(:, (1:ncards ~= imageCurrent)));
    imageCard = Screen('MakeTexture', window, images{imageCurrent});
    Screen('DrawTexture', window, imageCard, [], imgs(:, imageCurrent));
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    Screen('Close', imageTop);
    Priority(0);

    % Display the card for a time defined by cardDisplay
    WaitSecs(cardDisplay);
end

mt_showText(dirRoot, textPracticeRecall, window);

% In the recall sessions mouse interaction is activated
for iCard = 1: length(cardShown)
    % Get Trial Time
    TrialTime           = {datestr(now, 'HH:MM:SS.FFF')};
    
    % Get current picture
    imageCurrent    = cardShown(iCard);
    imageTop        = Screen('MakeTexture', window, imagesTop{imageCurrent});
    
    % Show a picture on top
%    Priority(MaxPriority(window)); 
    Screen('DrawTexture', window, imageTop, [], topCard);
    Screen('FrameRect', window, frameColor, topCard, frameWidth);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    Priority(0);

    HideCursor;
    imgCrossTex = Screen('MakeTexture', window, imgCross);
%    Priority(MaxPriority(window)); 
    Screen('DrawTexture', window, imageTop, [], topCard);
    Screen('FrameRect', window, frameColor, topCard, frameWidth);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    for iImage = 1:size(imgs, 2)
        tmp = CenterRectOnPointd(crossSize, rects(1, iImage)+cardSize(3)/2, rects(2, iImage)+cardSize(4)/2);
        tmp = reshape(tmp, 4, 1);
        Screen('DrawTexture', window, imgCrossTex, [], tmp);
    end
    Screen('Flip', window, flipTime);
    Screen('Close', imgCrossTex);
    Priority(0);
    WaitSecs(cardCrossDisplay);
%    Priority(MaxPriority(window)); 
    Screen('DrawTexture', window, imageTop, [], topCard);
    Screen('FrameRect', window, frameColor, topCard, frameWidth);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    Priority(0);
    ShowCursor(CursorType, window);
    
    % OnMouseClick: flip the card
    [cardFlip, mouseData(iCard, :)]	= mt_cardFlip(window, screenOff, ncards_x, cardSize+cardMargin, topCardHeigth, responseTime);
    cardClicked(iCard)  = cardFlip;
    
    % Show feedback
%    Priority(MaxPriority(window)); 
    Screen('DrawTexture', window, imageTop, [], topCard);
    Screen('FrameRect', window, frameColor, topCard, frameWidth);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    if cardFlip ~= 0
        if cardFlip == imageCurrent
            imageFeedback = Screen('MakeTexture', window, imgCorrect);
            % Correct: Show the green tick image
            Screen('DrawTexture', window, imageFeedback, ...
                [], [imgs(1:2, cardFlip)+feedbackMargin; imgs(3:4, cardFlip)-feedbackMargin]);
        else
            imageFeedback = Screen('MakeTexture', window, imgIncorrect);
            % Incorrect: Show the red cross image
            Screen('DrawTexture', window, imageFeedback, ...
                [], [imgs(1:2, cardFlip)+feedbackMargin; imgs(3:4, cardFlip)-feedbackMargin]);
            % Flip the correct image afterwards
            cardFlip = imageCurrent;
        end
    Screen('Flip', window, flipTime);
    Screen('Close', imageFeedback);
    Priority(0);
    WaitSecs(feedbackDisplay);

    % Flip the card
%    Priority(MaxPriority(window)); 
    Screen('DrawTexture', window, imageTop, [], topCard);
    Screen('FrameRect', window, frameColor, topCard, frameWidth);
    Screen('FillRect', window, cardColors, rects(:, (1:ncards ~= cardFlip)));
    imageFlip        = Screen('MakeTexture', window, images{cardFlip});
    Screen('DrawTexture', window, imageFlip, [], imgs(:, cardFlip));
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    Screen('Close', imageTop);
    Screen('Close', imageFlip);
    Priority(0);
    end

    % Display the card for a time defined by cardDisplay
    WaitSecs(cardRecallDisplay);
    
    
    % Compute trial performance
    correct             = (cardShown(iCard) - cardClicked(iCard)) + 1;
    correct(correct~=1) = 0;
    session             = {'Practice'};
    run                 = {1};
    
    imageShown          = imageFilesP(iCard);
    if cardClicked(iCard)~=0
        imageClicked   	= imageFilesP(iCard);
    else
        imageClicked    = {'NONE'};
    end
    
    coordsShown         = {mt_cards1Dto2D(cardShown(iCard), ncards_x, ncards_y)};
    coordsClicked       = {mt_cards1Dto2D(cardClicked(iCard), ncards_x, ncards_y)};
    mouseData           = mouseData(iCard, :);
    
    performance         = table(SessionTime, TrialTime, session, run, correct, imageShown, imageClicked,  mouseData, coordsShown, coordsClicked);

    % Save trial performance
    mt_saveTable(dirRoot, performance)
end


%% Performance    

% Save session performance
% Compute performance
correct             = (cardShown - cardClicked) + 1;
correct(correct~=1) = 0; % set others incorrect
% save cards shown, cards clicked, mouse click x/y coordinates, reaction time
accuracy            = 100 * mean(correct);
% save session data
mt_saveTable(dirRoot, performance, 0, accuracy)
