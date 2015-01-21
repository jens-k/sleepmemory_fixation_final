function MouseCard = mt_cardFlip(screenOff, ncards_x, cardSize, topCardSize)
%% TODO: Documentation

MousePress      = 0; %initializes flag to indicate no response

% While no mouse button is pressed
while    ( MousePress==0 ) 
    [x,y,buttons]   = GetMouse();   % wait for a key-press
    MousePress      = any(buttons); % sets to 1 if a button was pressed
    WaitSecs(.01);                  % put in small interval to allow other system events
end

% Get coordinates of mouse event
MouseCardX          = floor((x-screenOff(1))/cardSize(3))+1;
MouseCardY          = floor((y-(screenOff(2)+topCardSize))/cardSize(4))+1;
MouseCard           = ((MouseCardY-1) * ncards_x) + MouseCardX;

end