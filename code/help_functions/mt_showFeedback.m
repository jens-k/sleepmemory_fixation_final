function cardFlip = mt_showFeedback(dirRoot, window, cardFlip, feedbackOn, imageCurrent)
% ** mt_showFeedback(dirRoot, window, cardFlip, feedbackOn, imageCurrent)
% This function creates the cards, adds them to the buffer and displays the
% card matrix on the screen. Further, the memory task is initiated based 
% on the session type defined in the input dialogues
%
% USAGE:
%     cardFlip = mt_showFeedback(dirRoot, window, cardFlip, feedbackOn, imageCurrent)
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% dirRoot           char        path to root working directory
% window            double      current display window
% cardFlip          double      number of card which was clicked
% feedbackOn        double      if set to 1 feedback is shown
% imageCurrent      double      number of current image shown on top
% 
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Load parameters specified in mt_setup.m
load(fullfile(dirRoot,'setup','mt_params.mat'))   % load workspace information and properties

%% Set parameters
imageTop        = Screen('MakeTexture', window, images{imageCurrent});

% show feedback on the card
Priority(priority_level);
Screen('DrawTexture', window, imageTop, [], topCard);
Screen('FrameRect', window, frameColor, topCard, frameWidth);
Screen('FillRect', window, cardColors, rects);
Screen('FrameRect', window, frameColor, rects, frameWidth);
% No feedback
if feedbackOn == 0
    imageFeedback	= Screen('MakeTexture', window, imgNoFeedback);
    % Show the blue dot on the card which was clicked
    tmp = CenterRectOnPointd(circleSize, rects(1, cardFlip)+cardSize(3)/2, rects(2, cardFlip)+cardSize(4)/2);
    tmp = reshape(tmp, 4, 1);
    Screen('DrawTexture', window, imageFeedback, [], tmp);
    cardFlip = 0;
% Feedback for correct choice
elseif cardFlip == imageCurrent
    imageFeedback	= Screen('MakeTexture', window, imgCorrect);
    % Correct: Show the green tick image
    Screen('DrawTexture', window, imageFeedback, ...
        [], [imgs(1:2, cardFlip)+feedbackMargin; imgs(3:4, cardFlip)-feedbackMargin]);
% Feedback for wrong choice
else
    imageFeedback	= Screen('MakeTexture', window, imgIncorrect);
    % Incorrect: Show the red cross image
    Screen('DrawTexture', window, imageFeedback, ...
        [], [imgs(1:2, cardFlip)+feedbackMargin; imgs(3:4, cardFlip)-feedbackMargin]);
    % Flip the correct image afterwards
    cardFlip = imageCurrent;
end
Screen('Flip', window, flipTime);
Screen('Close', imageTop);
Screen('Close', imageFeedback);
Priority(0);
WaitSecs(feedbackDisplay);

end