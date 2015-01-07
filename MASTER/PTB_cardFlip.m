function MouseCard = PTB_cardFlip(screenOff, ncards_x, cardSize, topCardSize)

MousePress=0; %initializes flag to indicate no response
while    ( MousePress==0 ) %checks for completion
    [x,y,buttons]=GetMouse();  %waits for a key-press
    MousePress=any(buttons); %sets to 1 if a button was pressed
    WaitSecs(.01); % put in small interval to allow other system events
end
% Get coordinates of mouse event
MouseCardX = floor((x-screenOff(1))/cardSize(3))+1;
MouseCardY = floor((y-(screenOff(2)+topCardSize))/cardSize(4))+1;
MouseCard = ((MouseCardY-1) * ncards_x) + MouseCardX;

end