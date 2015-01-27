function mt_showIntro(rootdir, window)
% ** function mt_showText
% This function writes text to the window opened by Psychtoolbox via
% mt_window
%
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Load parameters specified in mt_setup.m
load(fullfile(rootdir,'code','mt_params.mat'))   % load workspace information and properties

% Draw introduction text on the screen
Screen('FillRect', window, introBgColor);
Screen('TextSize', window, textSize);
for line = 1: size(introText,1)-1
    DrawFormattedText(window, introText{line}, sx, sy+line*textSize*vspacing);
end
DrawFormattedText(window, introText{end}, sx, windowSize(2)-2*textSize);
Screen('Flip', window);

end