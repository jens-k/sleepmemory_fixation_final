function cfg = mt_window
%%

load('mt_params.mat')   % load workspace information and properties

%% Perform standard setup for PTB: 
% 0 - check mex file for Screen()
% 1 - additionally check mapping of key codes to key names
% 2 - additionally normalize color range from [0 255] to [0 1]
PsychDefaultSetup(2);

% Get screens connected
screens = Screen('Screens');

% Perform on external screen if available
screenNumber = max(screens);


%% Setup screen

% 1. Window Properties
% window - opened window
% windowRect - position array [left top right bottom]
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, 1);

% get the window center coordinates
[xCenter, yCenter] = RectCenter(windowRect);

% Format output
cfg.screen = [screens, screenNumber];
cfg.window = [window, windowRect];

% assure 4:3 format
cfg.window43 = cfg.window;
cfg.window43(end-1:end) = windowSize;
cfg.center = [xCenter, yCenter];

% 2. Timing

ifi                 = Screen('GetFlipInterval', window);
waitframes          = 1;
topPriorityLevel 	= MaxPriority(window);
Priority(topPriorityLevel);
vbl                 = Screen('Flip', window);
Priority(0);
flipTime            = vbl + (waitframes - 0.5) * ifi;

save('mt_params.mat', '-append', 'flipTime')

end