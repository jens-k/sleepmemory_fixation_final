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
ShowCursor;

%% Initialize variables for measured parameters
cardShown     	= imageSequencePractice;
cardClicked  	= zeros(length(cardShown), 1);
mouseData    	= zeros(length(cardShown), 3);

% Practice set
images(imageSequencePractice(1))   = Screen('MakeTexture', window, imread(fullfile(imgfolderP, imageFilesP{1})));
images(imageSequencePractice(2))   = Screen('MakeTexture', window, imread(fullfile(imgfolderP, imageFilesP{2})));
imagesTop(imageSequencePractice(1))   = Screen('MakeTexture', window, imread(fullfile(imgfolderP, 'top', imageFilesP{1})));
imagesTop(imageSequencePractice(2))   = Screen('MakeTexture', window, imread(fullfile(imgfolderP, 'top', imageFilesP{2})));

feedbackOn      = 1;

mt_showText(dirRoot, textPracticeLearn, window);

%% In the practice  learning session all pictures are shown in a sequence
for iCard = 1: length(cardShown)
    % Get current picture
    imageCurrent = cardShown(iCard);
    imageTop = imagesTop(imageCurrent);
    
    % Show a picture on top
    Priority(MaxPriority(window));
    Screen('DrawTexture', window, imageTop, [], topCard);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    Priority(0);
    WaitSecs(topCardDisplay);

    % Flip the card
    Priority(MaxPriority(window));
    Screen('DrawTexture', window, imageTop, [], topCard);

    % Fill all rects but the flipped one
    Screen('FillRect', window, cardColors, rects(:, (1:ncards ~= imageCurrent)));
    Screen('DrawTexture', window, images(imageCurrent), [], imgs(:, imageCurrent));
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    Priority(0);

    % Display the card for a time defined by cardDisplay
    WaitSecs(cardDisplay);
end

mt_showText(dirRoot, textPracticeRecall, window);

% In the recall sessions mouse interaction is activated
for iCard = 1: length(cardShown)
    % Get current picture
    imageCurrent = cardShown(iCard);
    imageTop = imagesTop(imageCurrent);
    
    % Show a picture on top
    Priority(MaxPriority(window));
    Screen('DrawTexture', window, imageTop, [], topCard);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    Priority(0);

    % OnMouseClick: flip the card
    [cardFlip, mouseData(iCard, :)]	= mt_cardFlip(screenOff, ncards_x, cardSize, topCardHeigth, responseTime);
    
    % Show feedback
    Priority(MaxPriority(window));
    Screen('DrawTexture', window, imageTop, [], topCard);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    if cardFlip == imageCurrent
        % Correct: Show the green tick image
        Screen('DrawTexture', window, Screen('MakeTexture', window, imgCorrect), ...
            [], [imgs(1:2, cardFlip)+feedbackMargin; imgs(3:4, cardFlip)-feedbackMargin]);
    else
        % Incorrect: Show the red cross image
        Screen('DrawTexture', window, Screen('MakeTexture', window, imgIncorrect), ...
            [], [imgs(1:2, cardFlip)+feedbackMargin; imgs(3:4, cardFlip)-feedbackMargin]);
        % Flip the correct image afterwards
        cardFlip = imageCurrent;
    end
    Screen('Flip', window, flipTime);
    Priority(0);
    WaitSecs(feedbackDisplay);

    % Flip the card
    Priority(MaxPriority(window));
    Screen('DrawTexture', window, imageTop, [], topCard);
    Screen('FillRect', window, cardColors, rects(:, (1:ncards ~= cardFlip)));
    Screen('DrawTexture', window, images(cardFlip), [], imgs(:, cardFlip));
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    Priority(0);

    % Display the card for a time defined by cardDisplay
    WaitSecs(cardRecallDisplay);
end