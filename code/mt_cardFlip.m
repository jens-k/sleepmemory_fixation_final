function MouseCard = mt_cardFlip(screenOff, ncards_x, cardSize, topCardHeigth)
% ** function mt_cardFlip(screenOff, ncards_x, cardSize, topCardHeigth)
% This function waits for a mouse press and returns the card number which
% was clicked. Importantly, only pressing the first mouse button is valid.
%
% USAGE:
%     mt_cardFlip(screenOff, ncards_x, cardSize, topCardHeigth)
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% screenOff         1X2 double  [Xoffset Yoffset] values result from
%                               difference between actual and 4:3 resolution
% ncards_x          1X1 double  number of cards in a row
% cardSize          1X4 double  [Xorigin Yorigin width height]
% topCardHeigth     1X1 double  height of the top card      
%
% <<< OUTPUT VARIABLES <<<
% NAME                TYPE      DESCRIPTION
% MouseCard         1X1 double  Scalar; the card which was clicked counted
%                               from left to right, top to bottom
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Wait for mouse button press
% Runs until a mouse button is pressed
MousePress      = 0; % initializes flag to indicate no response
while    ( MousePress==0 ) 
    [x,y,buttons]   = GetMouse();   % wait for a key-press
    % stop loop if the first mouse button is pressed
    if buttons(1)
        MousePress      = buttons(1); % sets to 1 if a button was pressed
        WaitSecs(.01);                % put in small interval to allow other system events
    end
end

%% Get coordinates of mouse event
MouseCardX          = floor((x-screenOff(1))/cardSize(3))+1;
MouseCardY          = floor((y-(screenOff(2)+topCardHeigth))/cardSize(4))+1;

%% Find out which card was selected and return the card number
MouseCard           = ((MouseCardY-1) * ncards_x) + MouseCardX;

end