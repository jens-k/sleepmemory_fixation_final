function cfg = mt_cards(cfg)
%% TODO: Documentation

imgfolder       = 'pics';
filesep         = '/';
% Define the display window 
win             = cfg.window(1);
% Specify number of cards
ncards_x        = 6;
ncards_y        = 5;
% Define in which order cards are flipped
cardSequence    = linspace(1,ncards_x*ncards_y);
cardSequence    = [1, 3, 4];
% Specify the card color
cardColors      = [0.5; 0.5; 0.5];

% Define window dimensions
screenSize      = cfg.window(end-1:end);
screenSize43    = cfg.window43(end-1:end);
[screenOff]     = [(screenSize(1)-screenSize43(1))/2 (screenSize(2)-screenSize43(2))/2];
topCardSize     = 300;

% Create top card
topCard         = CenterRectOnPointd([0 0 topCardSize topCardSize], screenSize43(1)/2+screenOff(1), topCardSize/2);

% Calculate coordinates for the ncards_y X ncards_x rectangles
cardCoordsX     = linspace(1,screenSize43(1),ncards_x+1)+screenOff(1);
cardCoordsX     = round(cardCoordsX(1:end-1) + (cardCoordsX(2)-cardCoordsX(1))/2);
cardCoordsY     = linspace(topCardSize,screenSize43(2),ncards_y+1);
cardCoordsY     = round(cardCoordsY(1:end-1) + (cardCoordsY(2)-cardCoordsY(1))/2);
    
% Make our rectangle coordinates
margin          = 5;
cardSize        = [0 0 round(screenSize43(1)/ncards_x)-margin round((screenSize43(2)-topCardSize)/ncards_y)-margin];

% the cardsAll vector stores all rectangles, the dimensions corresponds to
% the displayed ncards_y*ncards_x matrix
cardsAll        = zeros(ncards_y, 4, ncards_x);
for r = 1: length(cardCoordsY)
    for c = 1: length(cardCoordsX)
        cardsAll(r,:,c) = CenterRectOnPointd(cardSize, cardCoordsX(c), cardCoordsY(r));
    end
end

% the rects vector stores all rectangles in PTB format
rects           = zeros(4,ncards_x*ncards_y);
for r = 1: length(cardCoordsY)
    rects(:,(r-1)*ncards_x+1:r*ncards_x) = reshape(cardsAll(r,:,:),4,ncards_x);
end

% Read in the pictures for the cards
for r = 1: length(rects)
    pic         = imread([imgfolder filesep strcat(num2str(r), '.jpg')]);
    % TODO: create a ncards_x X ncards_y cell array with picture names?
    % for better overview define the image matrix in mt_setup
    images(r)   = Screen('MakeTexture', win, pic);
end


% Start the game: show all pictures in a sequence
for c = 1: length(cardSequence)

    % Draw the rects to the screen
    Priority(MaxPriority(win));
    Screen('FillRect', win, cardColors, topCard);
    Screen('FillRect', win, cardColors, rects);
    Screen('Flip', win);
    Priority(0);
    
    % Show a picture on top
    Priority(MaxPriority(win));
    Screen('DrawTexture', win, images(1), [], topCard);
    Screen('FillRect', win, cardColors, rects);
    Screen('Flip', win);
    Priority(0);

    % OnMouseClick: flip the card
    MouseCard       = mt_cardFlip(screenOff, ncards_x, cardSize, topCardSize);

    % Flip the card
    Priority(MaxPriority(win));
    Screen('DrawTexture', win, images(1), [], topCard);
    Screen('FillRect', win, cardColors, rects);
    Screen('DrawTexture', win, images(MouseCard), [], rects(:,MouseCard));
    Screen('Flip', win);
    Priority(0);
end
    
end