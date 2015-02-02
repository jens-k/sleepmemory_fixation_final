function card1D = mt_cards2Dto1D(coords, ncards_x, ncards_y)
% ** mt_cards2Dto1D(coords, ncards_x, ncards_y)
% Strings that define a position in a 2-D way are converted into
% the corresponding scalar index for cell iteration.
%
% Example:  
%       coord = mt_cards2Dto1D('B1', 6, 5);  => coord = 2;
%
% USAGE:
%       mt_cards2Dto1D(coords, ncards_x, ncards_y)
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% coords            char       	2-Dimensional coordinates, e.g. 'A1'
% ncards_x          double      number of cards in a row
% ncards_y          double      number of cards in a column
%
% <<< OUTPUT VARIABLES <<<
% NAME              TYPE        DESCRIPTION
% card1D            double      number for 1D cell iteration
%
% 
% AUTHOR: Marco Rüth, contact@marcorueth.com

% Generate alphabet
alphabet = 'A':'Z';

% Split the input string into char and number
coords_2D = [regexp(coords,'[A-Z]', 'match') regexp(coords,'\d+', 'match')];
coords_x = find(alphabet == coords_2D{1});
coords_y = str2double(coords_2D{2}) - 1;

% Compute 1D coordinate
if coords_x <= ncards_x && coords_y <= ncards_y
    card1D = coords_x +  coords_y * ncards_x;
else
    error('Coordinates in x and y direction must be <= cards in x and y direction');
end

end