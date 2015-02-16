controlList = [4, 6, 7, 3, 5, 6, 4, 6, 3, 4, 6, 4, 5, 7];

% create coordinates for cards that change color in the control task, while
% 2 succeeding coordinates may not be identical
X = cell(1, sum(controlList));
source = [1:30 1:30 randsample(1:30, 10, 1)];
seed = randsample(1:30, 1);
X{1} = mt_cards1Dto2D(seed, 6, 5);
for c = 2: sum(controlList)
    seed = randi(length(source), 1);
    if c <= 2
        while source(seed) == mt_cards2Dto1D(X{c-1}, 6, 5)
            seed = randi(length(source), 1);
        end
    else
        while source(seed) == mt_cards2Dto1D(X{c-1}, 6, 5) || source(seed) == mt_cards2Dto1D(X{c-2}, 6, 5)
            seed = randi(length(source), 1);
        end
    end
    X{c} = mt_cards1Dto2D(source(seed), 6, 5);
    source(seed) = [];
end