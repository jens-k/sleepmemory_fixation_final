function mt_showText(text, window)
% ** function mt_showText
% This function writes text to the window opened by Psychtoolbox via
% mt_window
%
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

Screen('TextSize', window, 70);
DrawFormattedText(window, text, 'center', 'center');
Screen('Flip', window);
KbWait;

end