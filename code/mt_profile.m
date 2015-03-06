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
        dirRoot             = 'D:\Master Thesis\00 - Program\';
        dirPTB              = 'D:\AnalysisSoftware\PTB\Psychtoolbox\';
    case {'MEG', 'SL3', 'SL4'}
        dirRoot 			= 'C:\Users\Doktorand\Desktop\Studies\GitHub\sleepmemory\';
        dirPTB              = 'C:\Users\Doktorand\Desktop\Studies\Psychtoolbox\';
    otherwise
        error('Invalid User Name. Define workspace in mt_profile.m')
end
addpath(genpath(dirRoot))
addpath(dirPTB)
end