function mt_controlTask(dirRoot, cfg_window, nCardsControl)
% ** function mt_controlTask(dirRoot, cfg_window, nCardsControl)
% This function initiates the control task.
%
% USAGE:
%     mt_controlTask(dirRoot, cfg_window)
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% dirRoot           char        path to root working directory
% cfg_window        struct      contains window information
%   .screen         1X2 double  [screens ScreenNumber]
%   .window         1X5 double  [window windowRect], actual resolution
%   .window43       1X5 double  [window windowRect], 4:3 resolution
%   .center         1X2 double  [Xcenter Ycenter]
% nCardsControl     double      number of cards flipped in the control task
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Load parameters specified in mt_setup.m
load(fullfile(dirRoot,'setup','mt_params.mat'))   % load workspace information and properties

%% Set window parameters
% Specify the display window 
window             = cfg_window.window(1);

%% Initialize variables for measured parameters
cardShown      = cardSequence{cfg_dlgs.sesstype}';
cardClicked    = zeros(length(cardShown), 1);
mouseData       = zeros(length(cardShown), 3);

%% Start the game
HideCursor;
% In the learning session all pictures are shown in a sequence
% In the recall sessions mouse interaction is activated

% Draw the rects to the screen
Priority(MaxPriority(window));
Screen('FillRect', window, cardColorControl, topCard);
Screen('FillRect', window, cardColors, rects);
Screen('FrameRect', window, frameColor, rects, frameWidth);
Screen('Flip', window, flipTime);
Priority(0);
WaitSecs(topCardDisplay);

for iCard = 1: nCardsControl
    cardCurrent = cardShown(iCard);
    
    % Flip the card
    Priority(MaxPriority(window));
    Screen('FillRect', window, cardColorControl, topCard);
    % Fill all rects but one
    Screen('FillRect', window, cardColors, rects(:, (1:ncards ~= cardCurrent)));
    Screen('FillRect', window, cardColorControl, rects(:, cardCurrent));
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    Priority(0);

    % Display the card for a time defined by cardDisplay
    WaitSecs(cardDisplay);
    
end

%% Ask how many cards changed their color up to now
ShowCursor;
nControlAnswers     = 4;
controlAnswers      = round(abs(nCardsControl-nControlAnswers):nCardsControl+nControlAnswers);
controlAnswers      = controlAnswers(controlAnswers~=nControlAnswers);
controlAnswers      = Shuffle([nCardsControl randsample(controlAnswers, 3, 0)]);

controlCardTextSize = 40;
controlCardHeigth   = 100;
controlCardWidth    = controlCardHeigth * (4/3);
controlRects        = zeros(4,nControlAnswers);

for cc = 1 : nControlAnswers
    controlRects(:, cc) = CenterRectOnPointd([0 0 controlCardWidth controlCardHeigth], cfg_window.center(1), cc*(controlCardHeigth+20));
end
Screen('TextSize', window, 20);               % set text size

Priority(MaxPriority(window));
Screen('FillRect', window, cardColors, controlRects);
Screen('FrameRect', window, frameColor, controlRects, frameWidth);
DrawFormattedText(window, 'Wie viele Karten haben die Farbe gewechselt?', 'center', 10, textDefColor);
Screen('TextSize', window, controlCardTextSize);
for cc = 1 : nControlAnswers
    DrawFormattedText(window, num2str(controlAnswers(cc)), 'center', ...
        (controlRects(4, cc)-(controlCardHeigth/2)-(controlCardTextSize*0.75)), textDefColor);
end
Screen('Flip', window, flipTime);
Priority(0);

mouseOnCard = zeros(nControlAnswers,1);
while ~(sum(mouseOnCard)==1)
    % Runs until a mouse button is pressed
    MousePress      = 0; % initializes flag to indicate no response
    while    ( MousePress==0 ) 
        [x, y, buttons]     = GetMouse();   % wait for a key-press
        % stop loop if the first mouse button is pressed
        if buttons(1)
            MousePress      = buttons(1); % sets to 1 if a button was pressed
            WaitSecs(.01);                % put in small interval to allow other system events
        end
    end

    for cc = 1 : nControlAnswers
        mouseOnCard(cc) = IsInRect(x, y, controlRects(:,cc));
    end
end
mouseOnCard        = find(mouseOnCard);
controlCardCorrect = find(controlAnswers == nCardsControl);

Screen('TextSize', window, 20);               % set text size

Priority(MaxPriority(window));
Screen('FillRect', window, cardColors, controlRects);
Screen('FrameRect', window, frameColor, controlRects, frameWidth);
DrawFormattedText(window, 'Wie viele Karten haben die Farbe gewechselt?', 'center', 10, textDefColor);
Screen('TextSize', window, controlCardTextSize);
if mouseOnCard == controlCardCorrect
    % Correct
    controlCardInds = find(1:nCardsControl ~= controlCardCorrect);
    for cc = 1 : nControlAnswers-1
    DrawFormattedText(window, num2str(controlAnswers(controlCardInds(cc))), 'center', ...
        (controlRects(4, controlCardInds(cc))-(controlCardHeigth/2)-(controlCardTextSize*0.75)), textDefColor);
    end
    Screen('TextStyle', window, 1);
    DrawFormattedText(window, num2str(controlAnswers(controlCardCorrect)), 'center', ...
        (controlRects(4, controlCardCorrect)-(controlCardHeigth/2)-(controlCardTextSize*0.75)), textColorCorrect);
    DrawFormattedText(window, 'Richtig', controlRects(1,1)+controlTextMargin, (controlRects(4, controlCardCorrect)-(controlCardHeigth/2)-(controlCardTextSize*0.75)), textColorCorrect);
else
    % Incorrect 
    controlCardInds = find((1:nCardsControl ~= controlCardCorrect) & (1:nCardsControl ~= mouseOnCard));
    for cc = 1 : nControlAnswers-2
    DrawFormattedText(window, num2str(controlAnswers(controlCardInds(cc))), 'center', ...
        (controlRects(4, controlCardInds(cc))-(controlCardHeigth/2)-(controlCardTextSize*0.75)), textDefColor);
    end
    Screen('TextStyle', window, 1);
    DrawFormattedText(window, num2str(controlAnswers(controlCardCorrect)), 'center', ...
        (controlRects(4, controlCardCorrect)-(controlCardHeigth/2)-(controlCardTextSize*0.75)), textColorCorrect);
    DrawFormattedText(window, num2str(controlAnswers(mouseOnCard)), 'center', ...
        (controlRects(4, mouseOnCard)-(controlCardHeigth/2)-(controlCardTextSize*0.75)), textColorIncorrect);
    DrawFormattedText(window, 'Richtig', controlRects(1,1)+controlTextMargin, (controlRects(4, controlCardCorrect)-(controlCardHeigth/2)-(controlCardTextSize*0.75)), textColorCorrect);
    DrawFormattedText(window, 'Falsch', controlRects(1,1)+controlTextMargin, (controlRects(4, mouseOnCard)-(controlCardHeigth/2)-(controlCardTextSize*0.75)), textColorIncorrect);
end
Screen('Flip', window, flipTime);
Priority(0);
WaitSecs(controlFeedbackDisplay);

Screen('TextStyle', window, 0);

end