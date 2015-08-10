function [dirRoot, dirPTB] = mt_profile(user)
% ** function mt_profile(user)
% Loads user-specific root directory and Psychtoolbox installation folder
%
% USAGE:
%       [dirRoot, dirPTB]   = mt_profile(user);
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% user              char       	user name
%
% <<< OUTPUT VARIABLES <<<
% NAME              TYPE        DESCRIPTION
% dirRoot           char        path to root working directory
% dirPTB            char        path to Psychtoolbox installation folder
%
% 
% AUTHOR:   Marco Rüth, contact@marcorueth.com
%           Jens Klinzing, jens.klinzing@uni-tuebingen.de

% Triggers for the different users are defined in mt_dialogues !

switch upper(user)
    case 0
        dirRoot             = 'C:\Users\t3ch\Documents\GitHub\sleepmemory\';
        dirPTB              = 'D:\Software\AnalysisSoftware\PTB\Psychtoolbox\';
    case {'MEG'}
        dirRoot 			= 'C:\Users\Doktorand\Desktop\Studies\GitHub\sleepmemory\';
        dirPTB              = 'C:\Users\Doktorand\Desktop\Studies\Psychtoolbox\';
    case {'SL3', 'SL4'}
        dirRoot 			= 'z:\Sleep Connectivity Marco Rueth\Memory Task 2'; % 'D:\SleepConnectivity\Memory Task';
        dirPTB              = 'C:\Users\Doktorand\Toolbox\Psychtoolbox';
    case {'MRI'}
       dirRoot              = 'E:\USERS\veit\memory_psychtoolbox\sleepmemory';
       dirPTB               = 'C:\Program Files\MATLAB\Psyschtoolbox\Psychtoolbox'; 
    case {'JENS'}
       dirRoot              = 'C:\Users\david\Documents\GitHub\sleepmemory';
       dirPTB               = 'C:\Users\david\Documents\MATLAB\Psychtoolbox'; 
        
    otherwise
        error('Invalid User Name. Define workspace in mt_profile.m')
end
addpath(genpath(dirRoot))
addpath(dirPTB)
end