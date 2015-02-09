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

switch user
    case 'marco'
        dirRoot             = 'D:\Master Thesis\00 - Program\';
        dirPTB              = 'D:\AnalysisSoftware\PTB\Psychtoolbox\';
    case 'jens'
        % dirRoot 			= ''
        % dirPTB 			= ''
    case 'SL'
        dirRoot 			= 'C:\Users\Olfactometer\Desktop\Studies\Code\sleepmemory\';
        dirPTB              = 'C:\Users\Olfactometer\Documents\MATLAB\Psychtoolbox\Psychtoolbox\';
    case 'MEG'
        % dirRoot 			= ''
        % dirPTB 			= ''
    otherwise
        error('Invalid User Name. Define workspace in mt_profile.m')
end
addpath(genpath(dirRoot))
addpath(dirPTB)
end