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
% AUTHOR: Marco Rüth, contact@marcorueth.com

switch upper(user)
    case 0
        dirRoot             = 'C:\Users\t3ch\Documents\GitHub\sleepmemory\';
        dirPTB              = 'D:\Software\AnalysisSoftware\PTB\Psychtoolbox\';
    case {'MEG'}
        dirRoot 			= 'C:\Users\Doktorand\Desktop\Studies\GitHub\sleepmemory\';
        dirPTB              = 'C:\Users\Doktorand\Desktop\Studies\Psychtoolbox\';
    case {'SL3', 'SL4'}
        dirRoot 			= 'D:\SleepConnectivity\';
        dirPTB              = 'C:\Users\Doktorand\Toolbox\Psychtoolbox';
    case {'MRI'}
       dirRoot              = 'E:\USERS\veit\memory_psychtoolbox\sleepmemory';
       dirPTB               = 'C:\Program Files\MATLAB\Psyschtoolbox\Psychtoolbox'; 
    otherwise
        error('Invalid User Name. Define workspace in mt_profile.m')
end
addpath(genpath(dirRoot))
addpath(dirPTB)
end