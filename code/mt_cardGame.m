function p_correct = mt_cardGame(rootdir, cfg_window, iRecall)
% ** function mt_cardGame(rootdir, cfg_window, iRecall)
% This function starts the memory task.
%
% USAGE:
%     mt_cardGame(rootdir, cfg_window, iRecall)
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% rootdir           char        path to root working directory
% cfg_window        struct      contains window information
%   .screen         1X2 double  [screens ScreenNumber]
%   .window         1X5 double  [window windowRect], actual resolution
%   .window43       1X5 double  [window windowRect], 4:3 resolution
%   .center         1X2 double  [Xcenter Ycenter]
% iRecall           double      current recall session
%
% <<< OUTPUT VARIABLES <<<
% NAME              TYPE        DESCRIPTION
% p_correct         double      Correctly clicked cards in percent
%
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Load parameters specified in mt_setup.m
load(fullfile(rootdir,'setup','mt_params.mat'))   % load workspace information and properties

%% Set window parameters
% Specify the display window 
window      	= cfg_window.window(1);

%% Initialize variables for measured parameters
cardShown     	= cardSequence{cfg_dlgs.sesstype}';
cardClicked  	= zeros(length(cardShown), 1);
mouseData    	= zeros(length(cardShown), 3);

%% Start the game
% In the learning session all pictures are shown in a sequence
% In the recall sessions mouse interaction is activated
for iCard = 1: length(cardShown)
    
    % Draw the rects to the screen
    Priority(MaxPriority(window));
    Screen('FillRect', window, topCardColor, topCard);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    Priority(0);

    ShowCursor;
    imageCurrent = cardShown(iCard);
    imageTop = images(imageCurrent);
    
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
            % The card with the same image shown on top will be flipped
            cardFlip        = imageCurrent;
        otherwise % Recall/Interference
            % OnMouseClick: flip the card
            [cardFlip, mouseData(iCard,:)] 	= mt_cardFlip(screenOff, ncards_x, cardSize, topCardHeigth);
            % Save which card was clicked
            cardClicked(iCard)           	= cardFlip;
            % Show Feedback
            cardFlip                        = mt_showFeedback(rootdir, window, cardFlip, feedbackOn, imageCurrent);
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

if cfg_dlgs.sesstype ~= 1 % if not learning session
    correct             = (cardShown - cardClicked) + 1;
    correct(correct~=1) = 0; % set others incorrect
    imageNames          = imageConfiguration{cfg_dlgs.memvers}';
    % save cards shown, cards clicked, mouse click x/y coordinates, reaction time
    performance         = table(correct, imageNames(cardShown), imageNames(cardClicked),  mouseData, cardShown, cardClicked);
    p_correct           = 100*sum(performance.correct)/length(performance.cardShown);

    % save performance of subject for each run with recall 
    save(fullfile(rootdir, subdir, ['mtp_sub_' cfg_dlgs.subject '_recall_' num2str(iRecall) '.mat']), 'performance', 'p_correct')
end
end