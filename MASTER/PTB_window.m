function cfg = PTB_window()

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
% Text properties
Screen('TextFont', window, 'Arial');
Screen('TextSize', window, 50);

% Format output
cfg.screen = [screens, screenNumber];
cfg.window = [window, windowRect];
cfg.center = [xCenter, yCenter];

end