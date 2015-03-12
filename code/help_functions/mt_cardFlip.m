function [mouseCard, mouseData] = mt_cardFlip(window, screenOff, ncards_x, cardSize, topCardHeigth, responseTime)
% ** function mt_cardFlip(window, screenOff, ncards_x, cardSize, topCardHeigth)
% This function waits for a mouse press and returns the card number which
% was clicked. Importantly, only pressing the first mouse button is valid.
%
% USAGE:
%     mt_cardFlip(window, screenOff, ncards_x, cardSize, topCardHeigth)
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% window            double  	window pointer
% screenOff         1X2 double  [Xoffset Yoffset] values result from
%                               difference between actual and 4:3 resolution
% ncards_x          double      number of cards in a row
% cardSize          1X4 double  [Xorigin Yorigin width height]
% topCardHeigth     double      height of the top card      
%
% <<< OUTPUT VARIABLES <<<
% NAME                TYPE      DESCRIPTION
% mouseCard         double      Scalar; the card which was clicked counted
%                               from left to right, top to bottom
% mouseData         1X3 double  [x, y, clickTime] mouse x/y coordinates 
%                               and reaction time
%
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Wait for mouse button press
clickTime   = 0;
buttonMouse = [];
% Runs until a mouse button is pressed
MousePress	= 0; % initializes flag to indicate no response
tic;
while   (MousePress == 0 && clickTime < responseTime)
    [x, y, buttonMouse]   = GetMouse(window);   % wait for a key-press
    % stop loop if the first mouse button is pressed
    if buttonMouse(1) && (x > screenOff(1) && x < (screenOff(1)+ncards_x*cardSize(3))) && (y > screenOff(2)+topCardHeigth)
        clickTime       = toc;
        MousePress      = buttonMouse(1); % sets to 1 if a button was presse
        break;
    end
    WaitSecs(.01);                % put in small interval to allow other system events
    clickTime       = toc;
end
mouseData = [x, y, clickTime];

if (clickTime < responseTime)
    %% Get coordinates of mouse event
    mouseCardX          = floor((x-screenOff(1))/(cardSize(3)))+1;
    mouseCardY          = floor((y-(screenOff(2)+topCardHeigth))/(cardSize(4)))+1;

    %% Find out which card was selected and return the card number
    mouseCard           = ((mouseCardY-1) * ncards_x) + mouseCardX;
else
    % Timout
    mouseCard           = 0;
end

end