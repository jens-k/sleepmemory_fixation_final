function coords_2D = mt_cards1Dto2D(coords, ncards_x, ncards_y)
% ** mt_cards1Dto2D(coords, ncards_x, ncards_y)
% Scalar index for cell iteration is converted to a strings that defines
% a position in a 2-D way.
%
% Example:  
%       coord = mt_cards1Dto2D(3, 6, 5);  => coord = 'C1';
%
% USAGE:
%       mt_cards1Dto2D(coords, ncards_x, ncards_y)
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% coords            char       	cell iteration index
% ncards_x          double      number of cards in a row
% ncards_y          double      number of cards in a column
%
% <<< OUTPUT VARIABLES <<<
% NAME              TYPE        DESCRIPTION
% card1D            double      2-Dimensional coordinates, e.g. 'A1'
%
% 
% AUTHOR: Marco Rüth, contact@marcorueth.com

% Generate alphabet
alphabet        = 'A':'Z';

% Compute 2D coordinates
inds            = mod(coords, ncards_x);
inds(inds==0)   = ncards_x;
coords_str      = alphabet(inds);
coords_num      = ceil(coords/ncards_x);

% Check if 2D coordinates are valid
if find(alphabet==coords_str) <= ncards_x && coords_num <= ncards_y
    coords_2D  = strcat(coords_str, num2str(coords_num)); 
else
    error('Coordinates in x and y direction must be <= cards in x and y direction');
end

end