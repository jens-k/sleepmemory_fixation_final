function [tableImagesA, tableImagesB] = mt_imageTable(imageConfiguration)
% ** mt_imageTable(imageConfiguration)
% Strings that define a position in a 2-D way are converted into
% the corresponding scalar index for cell iteration.
%
% USAGE:
%       [tableImagesA, tableImagesB] = mt_imageTable(imageConfiguration)
%
% >>> INPUT VARIABLES >>>
% NAME                  TYPE        DESCRIPTION
% imageConfiguration 	cell       	cell array with image names
%
% <<< OUTPUT VARIABLES <<<
% NAME                  TYPE        DESCRIPTION
% tableImagesA          table       table with alphabetic column names 
% tableImagesB          table       table with alphabetic column names
% 
% AUTHOR: Marco Rüth, contact@marcorueth.com

% Generate alphabet
alphabet = 'A':'Z';

% Create table with column names
tableImagesA = table();
tableImagesB = table();
for c = 1: size(imageConfiguration{1}, 2)
    tableImagesA = [tableImagesA cell2table(imageConfiguration{1}(:,c))];
    tableImagesB = [tableImagesB cell2table(imageConfiguration{2}(:,c))];
    tableImagesA.Properties.VariableNames{'Var1'} = alphabet(c);
    tableImagesB.Properties.VariableNames{'Var1'} = alphabet(c);
end
end