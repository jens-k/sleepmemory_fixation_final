function cardFlip = mt_showFeedback(rootdir, window, cardFlip, feedbackOn, imageCurrent)
% ** mt_showFeedback(rootdir, window, cardFlip, feedbackOn, imageCurrent)
% This function creates the cards, adds them to the buffer and displays the
% card matrix on the screen. Further, the memory task is initiated based 
% on the session type defined in the input dialogues
%
% USAGE:
%     cardFlip = mt_showFeedback(rootdir, window, cardFlip, feedbackOn, imageCurrent)
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% rootdir           char        path to root working directory
% window            double      current display window
% cardFlip          double      number of card which was clicked
% feedbackOn        double      if set to 1 feedback is shown
% imageCurrent      double      number of current image shown on top
% 
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Load parameters specified in mt_setup.m
load(fullfile(rootdir,'setup','mt_params.mat'))   % load workspace information and properties

%% Set parameters
imageTop = images(imageCurrent);

% show feedback on the card
Priority(MaxPriority(window));
Screen('DrawTexture', window, imageTop, [], topCard);
Screen('FillRect', window, cardColors, rects);
Screen('FrameRect', window, frameColor, rects, frameWidth);
% No feedback
if feedbackOn == 0
    % Show the blue dot on the card which was clicked
    Screen('DrawTexture', window, Screen('MakeTexture', window, imgNoFeedback), ...
        [], [imgs(1:2, cardFlip)+feedbackMargin; imgs(3:4, cardFlip)-feedbackMargin]);

    cardFlip = 0;
% Feedback for correct choice
elseif cardFlip == imageCurrent
    % Correct: Show the green tick image
    Screen('DrawTexture', window, Screen('MakeTexture', window, imgCorrect), ...
        [], [imgs(1:2, cardFlip)+feedbackMargin; imgs(3:4, cardFlip)-feedbackMargin]);
% Feedback for wrong choice
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

end