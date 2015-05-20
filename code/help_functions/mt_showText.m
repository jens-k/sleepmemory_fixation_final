function mt_showText(dirRoot, text, window, varargin)
% ** function mt_showText(dirRoot, text, window, varargin)
% This function writes text to the window opened by Psychtoolbox via
% mt_window
%
% USAGE:
%       mt_showText(dirRoot, text, window)
%       mt_showText(dirRoot, text, window, textSize)
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% dirRoot           char        path to root working directory
% text              char/cell   text to be displayed
% window            double      current display window
% varargin          double      optional; font size of the text
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Load parameters specified in mt_setup.m
load(fullfile(dirRoot,'setup','mt_params.mat'), 'textDefSize', 'textBgColor', ...
     'textSx', 'textSy', 'textVSpacing', 'textDefColor', 'windowSize')

delayContinue = 0;

 
if length(varargin) == 1
    textSize = varargin{1};
elseif length(varargin) == 2 && varargin{2} == 0
    textSize = textDefSize;
    delayContinue = 2;
elseif length(varargin) == 2 && varargin{2} == 1
    textSize = textDefSize;
    delayContinue = 'click';
else
    textSize = textDefSize;
end

Screen('FillRect', window, textBgColor);            % set background color
Screen('TextSize', window, textSize);               % set text size

% Set specific format if text is a cell array
if iscell(text)
    for line = 1: size(text,1)
        DrawFormattedText(window, text{line}, textSx, textSy+line*textSize*textVSpacing, textDefColor);
    end
else
    DrawFormattedText(window, text, 'center', 'center', textDefColor);
end
Screen('TextSize', window, textDefSize);
if delayContinue == 0
    DrawFormattedText(window, 'Weiter mit Mausklick...', textSx, windowSize(2)-2*textDefSize, textDefColor);
end

% Display the text
Screen('Flip', window); 

if isnumeric(delayContinue) && delayContinue ~= 0
    WaitSecs(delayContinue);
    Screen('Flip', window);
end

if (isnumeric(delayContinue) && delayContinue == 0) || (ischar(delayContinue) && strcmp(delayContinue, 'click'))
    % Wait until mouse click
    isClick = 0;
    while isClick == 0
        [~, ~, isClick]   = GetMouse(window);
        WaitSecs(.01);
    end
    % Wait until mouse released
    while sum(isClick) > 0 
        [~, ~, isClick]   = GetMouse(window);
        WaitSecs(.01);
    end
end


end