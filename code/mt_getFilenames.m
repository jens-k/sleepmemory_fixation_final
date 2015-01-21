function filename = mt_getFilenames(dirFiles, fileNo, plausibilityCheck)
% Every time you have a folder with files (eg. corresponding to the full
% set of subjects in T� notation) this function can be used to get the
% correct file. I think the only difference to hh_getCountFilenames is the
% plausibilitycheck.

% Use as
% filename = hh_getFilenames(dirFiles, subjNo, plausibilityCheck)
% eg.: filename = hh_getFilenames('C:\files\',5,1)
%      filelist = hh_getFilenames('C:\files\',0,1) 
%      filelist = hh_getFilenames('C:\files\')
%
% INPUT VARIABLES:
% dirFiles          String; input folder
% fileNo            int; subject for which the file is needed (in T� number
%                   notation).
%                   If 0, the whole filelist will be given back in a cell
%                   array.
% plausibilityCheck int; set 1 if you want to check whether the number of
%                   files is equal to the number of subjects (30).
%
% OUTPUT VARIABLES:
% filename          Name of the approproate file containing the given
%                   subject's data (usually preprocessed data or alike).
%                   If subjCount is set to 0 the ouput contains a list of
%                   all files in a cell array
%
% AUTHOR:
% Jens Klinzing, jens.klinzing@uni-tuebingen.de

dirData  = dir(dirFiles);               % Get the data for the current directory
dirIndex = [dirData.isdir];             % Find the index for directories
fileList = {dirData(~dirIndex).name}';  % ...and delete them out of the list
switch nargin
    case 3
        % do nothing
    case 2
        plausibilityCheck = 0;
    case 1
        plausibilityCheck = 0;
        fileNo = 0;

    otherwise
        error('Unexpected number of input arguments.');
end

if plausibilityCheck && length(fileList) ~= 30 && ~isempty(input('The number of files is not as expected (30). To continue, press ENTER: ','s'))
    error('Function aborted by layer 8.');
end

if fileNo ~= 0
    filename = fileList{fileNo};
else
    filename = fileList;
end

end