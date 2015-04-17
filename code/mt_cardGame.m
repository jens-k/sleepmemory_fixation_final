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
% Load port output for triggers
loadlibrary('trigger/inpoutx64', 'trigger/inpout32.h')
port = hex2dec('0378'); % LPT1: 0378 - 037F, 0778 - 077F

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

%% Initialize variables for measured parameters
cardShown     	= cardSequence{cfg_dlgs.memvers}{currSesstype}';
ntrials 		= length(cardShown);
cardClicked  	= zeros(ntrials, 1);
mouseData    	= zeros(ntrials, 3);
imageShown 		= cell(ntrials, 1);
imageClicked 	= cell(ntrials, 1);
coordsShown 	= cell(ntrials, 1);
coordsClicked 	= cell(ntrials, 1);
TrialTime 		= cell(ntrials, 1);


isinterf        = (cfg_dlgs.sesstype==3) + 1;
imagesT         = imageConfiguration{cfg_dlgs.memvers}{isinterf}';

%% Show which session is upcoming
mt_showText(dirRoot, textSession{currSesstype}, window, 40);
% Short delay after the mouse click to avoid motor artifacts
HideCursor(window);
Screen('Flip', window, flipTime);
WaitSecs(whiteScreenDisplay);
if ~((currSesstype == 2) || (currSesstype == 3))
    ShowCursor(CursorType, window);     % hide cursor during learning
end

%% Start the game
% MRI: wait for MRI trigger (5), then start the program
if isMRI
	triggerIn = [];
	while isempty(triggerIn)
		calllib('inpoutx64', 'Inp32', port)
	end 
end

% Get Session Time
SessionTime         = {datestr(now, 'HH:MM:SS')};
SessionTime(1:ntrials, 1) = SessionTime;
% In the learning session all pictures are shown in a sequence
% In the recall sessions mouse interaction is activated
% Make texture for fixation image
imageDot        = Screen('MakeTexture', window, imgDot);
imageDotSmall   = Screen('MakeTexture', window, imgDotSmall);
for iCard = 1: length(cardShown) 
   
    cardFlip = 0;
    % Get Trial Time
    TrialTime(iCard) 	= {datestr(now, 'HH:MM:SS.FFF')};
    
    % Get current picture
    imageCurrent    = cardShown(iCard);
    imageTop        = Screen('MakeTexture', window, images{imageCurrent});
    
    % Show a picture on top
	Priority(priority_level); 
    Screen('FillRect', window, cardColors, topCard);
    Screen('FrameRect', window, frameColor, topCard, frameWidth);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    Priority(0);
    WaitSecs(topCardGreyDisplay);
    
    Screen('DrawTexture', window, imageTop, [], topCard);
    Screen('FrameRect', window, frameColor, topCard, frameWidth);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    Priority(0);

    [mouseX, mouseY] = GetMouse(window);
    % Delay flipping in case of learning and immediate recall for topCardDisplay
    if ismember(currSesstype, 2:4) && ~isMRI
        
		% Send trigger during learning and immediate recall sessions
		if (cfg_dlgs.odor == 1)
			calllib('inpoutx64', 'Out32', port, triggerOdorOn{cfg_dlgs.lab})
		elseif (cfg_dlgs.odor == 0)
			calllib('inpoutx64', 'Out32', port, triggerPlaceboOn{cfg_dlgs.lab})
		end
        
        WaitSecs(topCardDisplay);
        if currSesstype == 4
            ShowCursor(CursorType, window);
        end
    else
        ShowCursor(CursorType, window);
    end
    SetMouse(mouseX, mouseY)
    
    
    % Define which card will be flipped
    switch currSesstype
        case {2, 3} % Learning (2) or Interference Learning (3)
            % The card with the same image shown on top will be flipped
            cardFlip            = imageCurrent;
            cardClicked(iCard)  = cardFlip; % dummy
        case {4, 5} % (Immediate) Recall
            % OnMouseClick: flip the card
            [cardFlip, mouseData(iCard,:)]	= mt_cardFlip(window, screenOff, ncards_x, cardSize+cardMargin, topCardHeigth, responseTime);
            if cardFlip ~= 0
                % Save which card was clicked
                cardClicked(iCard)           	= cardFlip;
                % Show Feedback
                cardFlip                        = mt_showFeedback(dirRoot, window, cardFlip, feedbackOn, imageCurrent);
            else
                % Timeout
                cardFlip                        = imageCurrent;
            end
        % Stop odor here in immediate recall sessions
        calllib('inpoutx64', 'Out32', port, 0)   % reset the port to 0 
    end
	reactionTime = mouseData(iCard, 3);
    HideCursor(window);
        
    if cardFlip ~= 0 && feedbackOn
        % Flip the card
		Priority(priority_level); 
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
        % Show fixation dots on cards only in learning sessions
        if ismember(currSesstype, 2:3)
            tmp = CenterRectOnPointd(dotSize, rects(1, imageCurrent)+cardSize(3)/2, rects(2, imageCurrent)+cardSize(4)/2);
            tmp = reshape(tmp, 4, 1);
            Screen('DrawTexture', window, imageDotSmall, [], tmp);
        end
        Screen('Flip', window, flipTime);
        Screen('Close', imageTop);
        Screen('Close', imageFlip);
        Priority(0);

        % Display the card for a pre-defined time
        if (currSesstype == 4) || (currSesstype == 5)
            WaitSecs(cardRecallDisplay);
        elseif isMRI 
			% Display time of lower card in recall session
			if MRIiti(iCard) - reactionTime < 0
				WaitSecs(reactionTime)
			else
				WaitSecs(0.5)
            end
		else
            WaitSecs(cardDisplay);
        end
    end
  
    % If in learning sessions
    if ismember(currSesstype, 2:4) && ~isMRI
        % Stop Odor here
        calllib('inpoutx64', 'Out32', port, 0)   % reset the port to 0 
    end

    imageShown(iCard) 	= imagesT(iCard);
    if cardClicked(iCard)~=0
        imageClicked(iCard) 	= imagesT(cardClicked(iCard));
    else
        imageClicked(iCard) 	= {'NONE'};
    end
    
    coordsShown(iCard)       = {mt_cards1Dto2D(cardShown(iCard), ncards_x, ncards_y)};
    coordsClicked(iCard)	 = {mt_cards1Dto2D(cardClicked(iCard), ncards_x, ncards_y)};
    
    % Time while subjects are allowed to blink
    Screen('Flip', window, flipTime);
    WaitSecs(interTrialInterval);
    
end
Screen('Close', imageDot);
Screen('Close', imageDotSmall);


% imageShown, imageClicked, coordsShown, coordsClicked

%% Performance    
% Save session performance
session             = zeros(ntrials, 1);
run                 = zeros(ntrials, 1);
session(1:ntrials, 1) = currSesstype;
run(1:ntrials, 1)   = iRun;
% Compute performance
correct             = (cardShown - cardClicked) + 1;
correct(correct~=1) = 0; % set others incorrect
% save cards shown, cards clicked, mouse click x/y coordinates, reaction time
accuracy            = 100 * mean(correct);
% save session data
performance         = table(SessionTime, TrialTime, session, run, correct, imageShown, imageClicked,  mouseData, coordsShown, coordsClicked);
mt_saveTable(dirRoot, performance, feedbackOn, accuracy)

% Return performance for recall session
if (currSesstype == 4) || (currSesstype == 5)
    perc_correct        = mean(correct);
else
    perc_correct    	= 1;
end

% Backup
fName = ['mtp_sub_' cfg_dlgs.subject '_night_' cfg_dlgs.night '_sess_' num2str(cfg_dlgs.sesstype)];
copyfile(fullfile(dirRoot, 'DATA', [fName '.*']), fullfile(dirRoot, 'BACKUP'), 'f');

% Housekeeping: unload port library
unloadlibrary('inpoutx64')

end