function cfg = mt_cards(cfg)
%% TODO: Documentation

load('mt_params.mat')   % load workspace information and properties


% Define the display window 
win             = cfg.window(1);

% Define window dimensions
screenSize      = cfg.window(end-1:end);
screenSize43    = windowSize;
[screenOff]     = [(screenSize(1)-screenSize43(1))/2 (screenSize(2)-screenSize43(2))/2];

% Create top card
topCard         = CenterRectOnPointd([0 0 topCardWidth topCardHeigth], screenSize43(1)/2+screenOff(1), topCardHeigth/2);

% Calculate coordinates for the ncards_y X ncards_x rectangles
cardCoordsX     = linspace(1,screenSize43(1),ncards_x+1)+screenOff(1);
cardCoordsX     = round(cardCoordsX(1:end-1) + (cardCoordsX(2)-cardCoordsX(1))/2);
cardCoordsY     = linspace(topCardHeigth,screenSize43(2),ncards_y+1);
cardCoordsY     = round(cardCoordsY(1:end-1) + (cardCoordsY(2)-cardCoordsY(1))/2);
    
% the cardsAll vector stores all rectangles, the dimensions corresponds to
% the displayed matrix with ncards
cardsAll        = zeros(ncards_y, 4, ncards_x);
for r = 1: length(cardCoordsY)
    for c = 1: length(cardCoordsX)
        cardsAll(r,:,c) = CenterRectOnPointd(cardSize, cardCoordsX(c), cardCoordsY(r));
    end
end


% the cardsAll vector stores all rectangles, the dimensions corresponds to
% the displayed matrix with ncards
imagesAll        = zeros(ncards_y, 4, ncards_x);
for r = 1: length(cardCoordsY)
    for c = 1: length(cardCoordsX)
        imagesAll(r,:,c)    = CenterRectOnPointd(imagesSize, cardCoordsX(c), cardCoordsY(r));
    end
end


% the rects/imgs vectors store all rectangles in PTB format
rects           = zeros(4,ncards);
for r = 1: length(cardCoordsY)
    rects(:,(r-1)*ncards_x+1:r*ncards_x)    = reshape(cardsAll(r,:,:), 4, ncards_x);
    imgs(:,(r-1)*ncards_x+1:r*ncards_x)     = reshape(imagesAll(r,:,:), 4, ncards_x);
end

% Read in the pictures for the cards
for r = 1: length(rects)
    if cfg_dlgs.memvers == 1
        pic_file 	= [imgfolderA filesep mt_getFilenames(imgfolderA, r, 1)];
    elseif cfg_dlgs.memvers == 2
        pic_file 	= [imgfolderB filesep mt_getFilenames(imgfolderB, r, 1)];
    end
    pic      	= imread(pic_file);
    % TODO: create a ncards_x X ncards_y cell array with picture names?
    % for better overview define the image matrix in mt_setup
    images(r)   = Screen('MakeTexture', win, pic);
end


% Start the game: show all pictures in a sequence
for c = 1: length(cardSequence{cfg_dlgs.memvers})

    imageTop = images(cardSequence{cfg_dlgs.memvers}(c));
    
    % Draw the rects to the screen
    Priority(MaxPriority(win));
    Screen('FillRect', win, topCardColor, topCard);
    Screen('FillRect', win, cardColors, rects);
    Screen('Flip', win, flipTime);
    Priority(0);
    
    % Show a picture on top
    Priority(MaxPriority(win));
    Screen('DrawTexture', win, imageTop, [], topCard);
    Screen('FillRect', win, cardColors, rects);
    Screen('Flip', win, flipTime);
    Priority(0);

    % Delay flipping in case of learning for cardDelay
    if cfg_dlgs.sesstype == 1
        WaitSecs(topCardDisplay);
    end
    
    
    % Define which card will be flipped
    switch cfg_dlgs.sesstype
        case 1 % Learning
            % the corresponding & correct card will be flipped
            cardFlip        = cardSequence{cfg_dlgs.memvers}(c);
        otherwise % Recall/Interfence
            % OnMouseClick: flip the card
            cardFlip        = mt_cardFlip(screenOff, ncards_x, cardSize, topCardHeigth);
    end


    % Flip the card
    Priority(MaxPriority(win));
    Screen('DrawTexture', win, imageTop, [], topCard);
    % Fill all rects but the flipped one
    Screen('FillRect', win, cardColors, rects(:, (1:ncards ~= cardFlip)));
    Screen('DrawTexture', win, images(cardFlip), [], imgs(:, cardFlip));
    Screen('Flip', win, flipTime);
    Priority(0);
    % Display the card for a time defined by cardDisplay
    WaitSecs(cardDisplay);
end
    
end