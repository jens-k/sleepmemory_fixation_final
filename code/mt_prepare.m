function dirRoot = mt_prepare(user)
% ** function dirRoot = mt_prepare(user)
% Initialization procedure for configuration. 
%
% 
% AUTHOR: Marco Rüth, contact@marcorueth.com

if ~nargin
    user = [];
end

% Generate workspace variables defined in mt_setup.m
try
    dirRoot = mt_setup(user);
catch ME
    fprintf(['Running mt_setup.m was unsuccessful.\n', ...
    'Check workspace variables and parameter settings.\n'])
    error(ME.message)
end

% Prompt to collect information about experiment
try
    mt_dialogues(dirRoot);
catch ME
    fprintf(['Calling mt_dialogues was unsuccessful.\n', ...
        'Type "help mt_dialogues" and follow the instructions for configuration.\n'])
    error(ME.message)
end

% Include Psychtoolbox to the path and open a fullscreen window
% TODO: Window management: do we want two screens to show different information (experimenter vs. subject)?
try
    sca;                % Clear all features related to PTB
    mt_window(dirRoot);
catch ME
    fprintf(['Opening a fullscreen window using Psychtoolbox was unsuccessful.\n', ...
        'Check variable dirPTB in mt_setup and check configuration of graphics card/driver.\n'])
    error(ME.message)
end
end