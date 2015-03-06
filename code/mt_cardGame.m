function perc_correct = mt_cardGame(dirRoot, cfg_window, iRun, varargin)
% ** function mt_cardGame(dirRoot, cfg_window, iRun)
% This function starts the memory task.
%
% USAGE:
%     mt_cardGame(dirRoot, cfg_window, iRun)
%     mt_cardGame(dirRoot, cfg_window, iRun, 1, 4) % feedback on, interference recall
%     mt_cardGame(dirRoot, cfg_window, iRun, 1, 5) % feedback on, main recall
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% dirRoot           char        path to root working directory
% cfg_window        struct      contains window information
%   .screen         1X2 double  [screens ScreenNumber]
%   .window         1X5 double  [window windowRect], actual resolution
%   .window43       1X5 double  [window windowRect], 4:3 resolution
%   .center         1X2 double  [Xcenter Ycenter]
% iRun              double      current recall session
% varargin          cell        optional: 
%                                   1. Feedback (0 or 1) 
%                                   2. Session type: [1, 5]
%
% <<< OUTPUT VARIABLES <<<
% NAME              TYPE        DESCRIPTION
% perc_correct      double      Correctly clicked cards in percent
%
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Load parameters specified in mt_setup.m
load(fullfile(dirRoot, 'setup', 'mt_params.mat'))   % load workspace information and properties

%% Set window parameters
% Specify the display window 
window      	= cfg_window.window(1);

%% Enable/Disable practice and feedback
feedbackOn	= 1;
if length(varargin) == 1
    feedbackOn	= varargin{1}; % if set to 0 a blue dot is shown instead of feedback 
elseif length(varargin) == 2
    feedbackOn	= varargin{1};
    currSesstype = varargin{2};
else
    currSesstype = cfg_dlgs.sesstype;
end
if (currSesstype == 4) || (currSesstype == 5)
    showCross = 1;  % show crosses 
elseif (currSesstype == 2)
    HideCursor;     % hide cursor during learning
end

%% Initialize variables for measured parameters
cardShown     	= cardSequence{cfg_dlgs.memvers}{currSesstype}';
cardClicked  	= zeros(length(cardShown), 1);
mouseData    	= zeros(1, 3);

isinterf        = (cfg_dlgs.sesstype==3) + 1;
imagesT         = imageConfiguration{cfg_dlgs.memvers}{isinterf}';
%% Show which session is upcoming
mt_showText(dirRoot, textSession{currSesstype}, window, 40);

%% Start the game
% Get Session Time
SessionTime         = {datestr(now, 'HH:MM:SS')};
% In the learning session all pictures are shown in a sequence
% In the recall sessions mouse interaction is activated
for iCard = 1: length(cardShown)
    % Get Trial Time
    TrialTime           = {datestr(now, 'HH:MM:SS.FFF')};
    
    % Get current picture
    imageCurrent    = cardShown(iCard);
    imageTop        = Screen('MakeTexture', window, imagesTop{imageCurrent});
    
    % Show a picture on top
    Priority(MaxPriority(window));
    Screen('DrawTexture', window, imageTop, [], topCard);
    Screen('FrameRect', window, frameColor, topCard, frameWidth);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    Priority(0);

    % Delay flipping in case of learning for cardDelay
    if currSesstype == 2 || currSesstype == 3
        WaitSecs(topCardDisplay);
    % Show fixation crosses
    elseif showCross == 1
        HideCursor;
        imgCrossTex = Screen('MakeTexture', window, imgCross);
        Priority(MaxPriority(window));
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
        Priority(MaxPriority(window));
        Screen('DrawTexture', window, imageTop, [], topCard);
        Screen('FrameRect', window, frameColor, topCard, frameWidth);
        Screen('FillRect', window, cardColors, rects);
        Screen('FrameRect', window, frameColor, rects, frameWidth);
        Screen('Flip', window, flipTime);
        Priority(0);
        ShowCursor;
    else
        ShowCursor;
    end
    
    % Define which card will be flipped
    switch currSesstype
        case {2, 3} % Learning (2) or Interference Learning (3)
            % The card with the same image shown on top will be flipped
            cardFlip            = imageCurrent;
            cardClicked(iCard)  = cardFlip; % dummy
        case {4, 5} % (Immediate) Recall
            % OnMouseClick: flip the card
            [cardFlip, mouseData]	= mt_cardFlip(screenOff, ncards_x, cardSize+cardMargin, topCardHeigth, responseTime);
            if cardFlip ~= 0
                % Save which card was clicked
                cardClicked(iCard)           	= cardFlip;
                % Show Feedback
                cardFlip                        = mt_showFeedback(dirRoot, window, cardFlip, feedbackOn, imageCurrent);
            end
    end
        
    if cardFlip ~= 0 && feedbackOn
        % Flip the card
        Priority(MaxPriority(window));
        Screen('DrawTexture', window, imageTop, [], topCard);
        Screen('FrameRect', window, frameColor, topCard, frameWidth);

        % Fill all rects but the flipped one
        if cardFlip
            Screen('FillRect', window, cardColors, rects(:, (1:ncards ~= cardFlip)));
            imageFlip = Screen('MakeTexture', window, images{cardFlip});
            Screen('DrawTexture', window, imageFlip, [], imgs(:, cardFlip));
        else
            % No cardFlip in last recall session
            Screen('FillRect', window, cardColors, rects);
        end
        Screen('FrameRect', window, frameColor, rects, frameWidth);
        Screen('Flip', window, flipTime);
        Screen('Close', imageTop);
        Screen('Close', imageFlip);
        Priority(0);

        % Display the card for a pre-defined time
        if (currSesstype == 4) || (currSesstype == 5)
            WaitSecs(cardRecallDisplay);
        else
            WaitSecs(cardDisplay);
        end
    end
  
    
    % Compute trial performance
    correct             = (cardShown(iCard) - cardClicked(iCard)) + 1;
    correct(correct~=1) = 0;
    session             = currSesstype;
    run                 = iRun;
    
    imageShown          = imagesT(iCard);
    if cardClicked(iCard)~=0
        imageClicked   	= imagesT(cardClicked(iCard));
    else
        imageClicked    = {'NONE'};
    end
    
    coordsShown         = {mt_cards1Dto2D(cardShown(iCard), ncards_x, ncards_y)};
    coordsClicked       = {mt_cards1Dto2D(cardClicked(iCard), ncards_x, ncards_y)};

    performance         = table(SessionTime, TrialTime, session, run, correct, imageShown, imageClicked,  mouseData, coordsShown, coordsClicked);

    % Save trial performance
    mt_saveTable(dirRoot, performance, feedbackOn)
end

%% Performance    

% Save session performance
% Compute performance
correct             = (cardShown - cardClicked) + 1;
correct(correct~=1) = 0; % set others incorrect
% save cards shown, cards clicked, mouse click x/y coordinates, reaction time
accuracy            = 100 * mean(correct);
% save session data
mt_saveTable(dirRoot, performance, feedbackOn, accuracy)

% % Show performance for recall session
% if (currSesstype == 4) || (currSesstype == 5)
%     mt_showText(dirRoot, [sprintf('%.f', 100*mean(correct)) '% (' sprintf('%.f', sum(correct)) ' von ' sprintf('%.f', length(correct)) ') waren korrekt!'], window);
% end

% Return performance for recall session
if (currSesstype == 4) || (currSesstype == 5)
    perc_correct        = mean(correct);
else
    perc_correct    	= 1;
end

% Backup
fName = ['mtp_sub_' cfg_dlgs.subject '_night_' cfg_dlgs.night '_sess_' num2str(cfg_dlgs.sesstype)];
copyfile(fullfile(dirRoot, 'DATA', [fName '.*']), fullfile(dirRoot, 'BACKUP'), 'f');

end