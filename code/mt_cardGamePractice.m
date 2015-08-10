function perc_correct  = mt_cardGamePractice(dirRoot, cfg_window)
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
% <<< OUTPUT VARIABLES <<<
% NAME              TYPE        DESCRIPTION
% perc_correct      double      Correctly clicked cards in percent
%
% AUTHOR:   Marco Rüth, contact@marcorueth.com
%           Jens Klinzing, jens.klinzing@uni-tuebingen.de

%% Load parameters specified in mt_setup.m
load(fullfile(dirRoot, 'setup', 'mt_params.mat'))   % load workspace information and properties

%% Set window parameters
% Specify the display window 
window      	= cfg_window.window(1);

%% Initialize variables for measured parameters
cardShown     	= imageSequencePractice';
ntrials 		= length(cardShown);
cardClicked  	= zeros(length(cardShown), 1);
mouseData    	= zeros(length(cardShown), 3);
imageShown 		= cell(ntrials, 1);
imageClicked 	= cell(ntrials, 1);
coordsShown 	= cell(ntrials, 1);
coordsClicked 	= cell(ntrials, 1);
TrialTime 		= cell(ntrials, 1);

% Practice set
for i = 1: length(imageFilesP)
    pic_file = fullfile(imgfolderP, imageFilesP{i});
    images{imageSequencePractice(i)}	= imread(pic_file);
end


% Calculate coordinates for the ncards_y X ncards_x rectangles
cardCoordsX     = [cfg_window.center(1)-cardWidth cfg_window.center(1) cfg_window.center(1)+cardWidth];
cardCoordsY     = [topCardHeigth+cardHeigth topCardHeigth+2*cardHeigth topCardHeigth+3*cardHeigth];
ncards          = length(cardCoordsX) * length(cardCoordsY);

% The cardsAll vector stores all rectangles that cover the images
cardsAll        = zeros(length(cardCoordsY), 4, length(cardCoordsX));
for r = 1: length(cardCoordsY)
    for iCard = 1: length(cardCoordsX)
        cardsAll(r,:,iCard) = CenterRectOnPointd(cardSize, cardCoordsX(iCard), cardCoordsY(r));
    end
end

% The imagesAll vector stores all rectangles in which images are displayed
imagesAll        = zeros(length(cardCoordsY), 4, length(cardCoordsX));
for r = 1: length(cardCoordsY)
    for iCard = 1: length(cardCoordsX)
        imagesAll(r,:,iCard)    = CenterRectOnPointd(imagesSize, cardCoordsX(iCard), cardCoordsY(r));
    end
end

% The rects/imgs vectors store all rectangles in PTB format
rects           = zeros(4,ncards);
imgs            = zeros(4,ncards);
for r = 1: length(cardCoordsY)
    rects(:,(r-1)*length(cardCoordsX)+1:r*length(cardCoordsX))  = reshape(cardsAll(r,:,:), 4, length(cardCoordsX));
    imgs(:,(r-1)*length(cardCoordsX)+1:r*length(cardCoordsX))   = reshape(imagesAll(r,:,:), 4, length(cardCoordsX));
end

mt_showText(dirRoot, textPracticeLearn, window);
% Short delay after the mouse click to avoid motor artifacts
HideCursor(window);
Screen('Flip', window, flipTime);
WaitSecs(whiteScreenDisplay);


%% In the practice learning session all pictures are shown in a sequence
% Get Session Time
SessionTime         = {datestr(now, 'HH:MM:SS')};
SessionTime(1:ntrials, 1) = SessionTime;
% Make texture for fixation image
imageDot        = Screen('MakeTexture', window, imgDot);
imageDotSmall   = Screen('MakeTexture', window, imgDotSmall);
for iCard = 1: length(cardShown)
    % Get Trial Time
    TrialTime(iCard) 	= {datestr(now, 'HH:MM:SS.FFF')};
    
    % Get current picture
    imageCurrent    = cardShown(iCard);
    imageTop        = Screen('MakeTexture', window, images{imageCurrent});
    
    % Show topCard in Grey
    Screen('FillRect', window, cardColors, topCard);
    Screen('FrameRect', window, frameColor, topCard, frameWidth);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    Priority(0);
    WaitSecs(topCardGreyDisplay);
    
    % Show a picture on top
%    Priority(MaxPriority(window)); 
    Screen('DrawTexture', window, imageTop, [], topCard);
    Screen('FrameRect', window, frameColor, topCard, frameWidth);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    %    Priority(0);
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
    tmp = CenterRectOnPointd(dotSize, rects(1, imageCurrent)+cardSize(3)/2, rects(2, imageCurrent)+cardSize(4)/2);
    tmp = reshape(tmp, 4, 1);
    Screen('DrawTexture', window, imageDotSmall, [], tmp);
    Screen('Flip', window, flipTime);
    Screen('Close', imageTop);
    %    Priority(0);

    % Display the card for a time defined by cardDisplay
    WaitSecs(cardDisplay);
    
    
    tic
    % Compute trial performance
    cardFlip            = imageCurrent;
    cardClicked(iCard)  = cardFlip;
    correct             = (cardShown(iCard) - cardClicked(iCard)) + 1;
    correct(correct~=1) = 0;
    
    imageShown(iCard)   = imageFilesP(iCard);
    imageClicked(iCard) = imageFilesP(iCard);
    
    coordsShown(iCard)  = {mt_cards1Dto2D(cardShown(iCard), length(cardCoordsX), length(cardCoordsY))};
    coordsClicked(iCard)= {mt_cards1Dto2D(cardClicked(iCard), length(cardCoordsX), length(cardCoordsY))};
    mouseData(iCard,:)  = [0, 0, 0];
        
    % Time while subjects are allowed to blink
    Screen('Flip', window, flipTime);
    WaitSecs(interTrialInterval);
end

% Save session performance
session                 = cell(ntrials, 1);
run                     = zeros(ntrials, 1);
session(1:ntrials, 1)   = {'Practice'};
run(1:ntrials, 1)       = 1;

% Compute performance
correct             = (cardShown - cardClicked) + 1;
correct(correct~=1) = 0; % set others incorrect
performance_learn         = table(SessionTime, TrialTime, session, run, correct, imageShown, imageClicked,  mouseData, coordsShown, coordsClicked);


% RECALL
mt_showText(dirRoot, textPracticeRecall, window);

SessionTime         = {datestr(now, 'HH:MM:SS')};
SessionTime(1:ntrials, 1) = SessionTime;

% In the recall sessions mouse interaction is activated
for iCard = 1: length(cardShown)
    % Get Trial Time
    TrialTime(iCard) 	= {datestr(now, 'HH:MM:SS.FFF')};
    
    % Get current picture
    imageCurrent    = cardShown(iCard);
    imageTop        = Screen('MakeTexture', window, images{imageCurrent});
    
    % Show topCard in Grey
    Screen('FillRect', window, cardColors, topCard);
    Screen('FrameRect', window, frameColor, topCard, frameWidth);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    Priority(0);
    WaitSecs(topCardGreyDisplay);
    
    
    % Show a picture on top
%    Priority(MaxPriority(window)); 
    Screen('DrawTexture', window, imageTop, [], topCard);
    Screen('FrameRect', window, frameColor, topCard, frameWidth);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    %    Priority(0);

    ShowCursor(CursorType, window);
%    Priority(MaxPriority(window)); 
    Screen('DrawTexture', window, imageTop, [], topCard);
    Screen('FrameRect', window, frameColor, topCard, frameWidth);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    %    Priority(0);
    
    
    % OnMouseClick: flip the card
    mouseOnCard = zeros(ncards, 1);
    while ~(sum(mouseOnCard)==1)
        tic;
        % Runs until a mouse button is pressed
        MousePress      = 0; % initializes flag to indicate no response
        while    ( MousePress==0 ) 
            [x, y, buttons]     = GetMouse(window);   % wait for a key-press
            % stop loop if the first mouse button is pressed
            if buttons(1)
                clickTime       = toc;
                MousePress      = buttons(1); % sets to 1 if a button was pressed
                WaitSecs(.01);                % put in small interval to allow other system events
            end
        end

        for cc = 1 : ncards
            mouseOnCard(cc) = IsInRect(x, y, rects(:,cc));
        end
    end
    mouseOnCard        = find(mouseOnCard);
    mouseData(iCard, :) = [x, y, clickTime];
    
    cardFlip = mouseOnCard;
    cardClicked(iCard)  = cardFlip;
    HideCursor(window);
    
    % Show feedback
%    Priority(MaxPriority(window)); 
    Screen('DrawTexture', window, imageTop, [], topCard);
    Screen('FrameRect', window, frameColor, topCard, frameWidth);
    Screen('FillRect', window, cardColors, rects);
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    if cardFlip ~= 0 
        % the next lines could be replaced by only one case. It was kept 
        % like this due to legacy and in case the practice run should at 
        % one point give feedback again
        if cardFlip == imageCurrent % if the answer was correct
            imageFeedback = Screen('MakeTexture', window, imgNoFeedback); % used to be imgCorrect
            tmp = CenterRectOnPointd(circleSize, rects(1, cardFlip)+cardSize(3)/2, rects(2, cardFlip)+cardSize(4)/2);
            tmp = reshape(tmp, 4, 1);
            Screen('DrawTexture', window, imageFeedback, [], tmp);
        else % if the answer was incorrect
            imageFeedback = Screen('MakeTexture', window, imgNoFeedback); % used to be imgIncorrect
            tmp = CenterRectOnPointd(circleSize, rects(1, cardFlip)+cardSize(3)/2, rects(2, cardFlip)+cardSize(4)/2);
            tmp = reshape(tmp, 4, 1);
            Screen('DrawTexture', window, imageFeedback, [], tmp);
            % Flip the correct image afterwards
            cardFlip = imageCurrent;
        end
    Screen('Flip', window, flipTime);
    Screen('Close', imageFeedback);
    %    Priority(0);
    WaitSecs(feedbackDisplay);

    % In the past the card was flipped here
    % Priority(MaxPriority(window)); 
%     Screen('DrawTexture', window, imageTop, [], topCard);
%     Screen('FrameRect', window, frameColor, topCard, frameWidth);
%     Screen('FillRect', window, cardColors, rects(:, (1:ncards ~= cardFlip)));
%     imageFlip        = Screen('MakeTexture', window, images{cardFlip});
%     Screen('DrawTexture', window, imageFlip, [], imgs(:, cardFlip));
%     Screen('FrameRect', window, frameColor, rects, frameWidth);
%     Screen('Flip', window, flipTime);
%     Screen('Close', imageTop);
%     Screen('Close', imageFlip);
    %    Priority(0);
    end

    % Display the card for a time defined by cardDisplay
    WaitSecs(cardRecallDisplay);
    
    imageShown(iCard)          = imageFilesP(iCard);
    if cardClicked(iCard)~=0
        imageClicked(iCard)   	= imageFilesP(iCard);
    else
        imageClicked(iCard)  = {'NONE'};
    end
    
    coordsShown(iCard)       = {mt_cards1Dto2D(cardShown(iCard), ncards_x, ncards_y)};
    coordsClicked(iCard)	 = {mt_cards1Dto2D(cardClicked(iCard), ncards_x, ncards_y)};
    
    % Time while subjects are allowed to blink
    Screen('Flip', window, flipTime);
    WaitSecs(interTrialInterval);
end
Screen('Close', imageDot);
Screen('Close', imageDotSmall);


%% Performance    

% Save session performance
session                 = cell(ntrials, 1);
run                     = zeros(ntrials, 1);
session(1:ntrials, 1)   = {'Practice'};
run(1:ntrials, 1)       = 1;
% Compute performance
correct             = (cardShown - cardClicked) + 1;
correct(correct~=1) = 0; % set others incorrect

performance_recall         = table(SessionTime, TrialTime, session, run, correct, imageShown, imageClicked,  mouseData, coordsShown, coordsClicked);

performance = [performance_learn; performance_recall];

% save cards shown, cards clicked, mouse click x/y coordinates, reaction time
accuracy            = 100 * mean(correct);
% save session data
mt_saveTable(dirRoot, performance, 0, accuracy)

% generate output
perc_correct        = mean(correct);
