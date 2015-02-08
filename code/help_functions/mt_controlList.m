function mt_controlList(dirRoot)
% ** function mt_controlList
% This function creates lists for the control task.
%
% USAGE:
%     mt_controlList(dirRoot)
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% dirRoot           char        path to root working directory
%
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

nLists        	= 100;      % number of different lists
controlCards 	= 100;      % number of total cards per subject
controlPrompts 	= 10;       % number of runs of control task

% Pre-allocate memory for lists
controlList  	= zeros(nLists, controlPrompts);
tmpList         = zeros(1, controlPrompts);

for list = 1 : nLists
    % Random sampling of a list with elements that sum up to 100
    while (sum(tmpList) ~= controlCards) || ismember(tmpList, controlList, 'rows')
        tmpList       = randsample(5:15, controlPrompts);
    end
    controlList(list, :) = tmpList;
end

save(fullfile(dirRoot, 'controlList.mat'), 'controlList');

end