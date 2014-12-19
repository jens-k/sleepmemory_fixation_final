function cfg = PTB_cards(cfg)
%%
% define the display window 
win = cfg.window(1);
% Specify number of cards
ncards_x = 6;
ncards_y = 5;
% Specify the card color
cardColors = [0.5; 0.5; 0.5];

screenSize = cfg.window(end-1:end);
topCardSize = 300;

% Create top card
topCard = CenterRectOnPointd([0 0 topCardSize topCardSize], screenSize(1)/2, topCardSize/2);

% Calculate coordinates for the ncards_y X ncards_x rectangles
cardCoordsX = linspace(1,screenSize(1),ncards_x+1);
cardCoordsX = round(cardCoordsX(1:end-1) + (cardCoordsX(2)-cardCoordsX(1))/2);
cardCoordsY = linspace(topCardSize,screenSize(2),ncards_y+1);
cardCoordsY = round(cardCoordsY(1:end-1) + (cardCoordsY(2)-cardCoordsY(1))/2);

% Make our rectangle coordinates
margin = 5;
cardSize = [0 0 round(screenSize(1)/ncards_x)-margin round((screenSize(2)-topCardSize)/ncards_y)-margin];

cardsAll = zeros(ncards_y, 4, ncards_x);
for r = 1: length(cardCoordsY)
    for c = 1: length(cardCoordsX)
        cardsAll(r,:,c) = CenterRectOnPointd(cardSize, cardCoordsX(c), cardCoordsY(r));
    end
end

% Draw the rects to the screen
Priority(MaxPriority(win));
Screen('FillRect', win, cardColors, topCard);
for r = 1: length(cardCoordsY)
    cards = reshape(cardsAll(r,:,:),4,ncards_x);
    Screen('FillRect', win, cardColors, cards);
end
Screen('Flip', win);
Priority(0);


end