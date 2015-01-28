function mt_controlTask(rootdir, cfg_window)
% ** function mt_controlTask(rootdir, cfg_window)
% This function initiates the control task.
%
% USAGE:
%     mt_controlTask(rootdir, cfg_window)
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% rootdir           char        path to root working directory
% cfg_window        struct      contains window information
%   .screen         1X2 double  [screens ScreenNumber]
%   .window         1X5 double  [window windowRect], actual resolution
%   .window43       1X5 double  [window windowRect], 4:3 resolution
%   .center         1X2 double  [Xcenter Ycenter]
%
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Load parameters specified in mt_setup.m
load(fullfile(rootdir,'setup','mt_params.mat'))   % load workspace information and properties

%% Set window parameters
% Specify the display window 
window             = cfg_window.window(1);

% Specify card colors
cardColorDark         = 0.3;

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
Screen('FillRect', window, cardColorDark, topCard);
Screen('FillRect', window, cardColors, rects);
Screen('FrameRect', window, frameColor, rects, frameWidth);
Screen('Flip', window, flipTime);
Priority(0);
WaitSecs(topCardDisplay);

for iCard = 1: length(cardShown)
    cardCurrent = cardShown(iCard);
    
    % Flip the card
    Priority(MaxPriority(window));
    Screen('FillRect', window, cardColors, topCard);
    % Fill all rects but one
    Screen('FillRect', window, cardColors, rects(:, (1:ncards ~= cardCurrent)));
    Screen('FillRect', window, cardColorDark, rects(:, cardCurrent));
    Screen('FrameRect', window, frameColor, rects, frameWidth);
    Screen('Flip', window, flipTime);
    Priority(0);

    % Display the card for a time defined by cardDisplay
    WaitSecs(cardDisplay);
    
    % Ask how many cards changed their color up to now
end

end