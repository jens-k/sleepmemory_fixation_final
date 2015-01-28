function [rootdir, PTBdir] = mt_loadUser(user)
% ** function mt_loadUser(user)
% Loads user-specific root directory and Psychtoolbox installation folder
%
% USAGE:
%       [rootdir, PTBdir]   = mt_loadUser(user);
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% user              char       	pre-defined user name
%
% <<< OUTPUT VARIABLES <<<
% NAME              TYPE        DESCRIPTION
% rootdir           char        path to root working directory
% PTBdir            char        path to Psychtoolbox installation folder
%
% 
% AUTHOR: Marco Rüth, contact@marcorueth.com

switch user
    case 'marco'
        rootdir             = 'D:\Master Thesis\00 - Program\';
        PTBdir              = 'D:\AnalysisSoftware\PTB\Psychtoolbox\';
    case 'jens'
        % rootdir
        % PTBdir
    case 'SL'
        % rootdir
        % PTBdir
    case 'MEG'
        % rootdir
        % PTBdir
    otherwise
        error('Invalid User Name. Define workspace manually in mt_setup.m')
end
end