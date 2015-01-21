%%

%% System variables
filesep             = '/';
% win                 = % define which display window is used
%% Folders
% root
workdir             = 'D:\Studium Tübingen\Master Thesis\00 - Program\';
% picture folder
imgfolder           = 'pics';


%% Cards
% Specify number of cards
ncards_x        = 6;
ncards_y        = 5;
% Card properties
topCardSize     = 300;
margin          = 5;
cardSize        = [0 0 round(screenSize43(1)/ncards_x)-margin round((screenSize43(2)-topCardSize)/ncards_y)-margin];
% Define in which order cards are flipped
cardSequence    = linspace(1,ncards_x*ncards_y);

%% save ...