controlList = [0, 4, 6, 7, 3, 5, 6, 4, 6, 3, 4, 6, 4, 5, 7];

% create coordinates for cards that change color in the control task, while
% 2 succeeding coordinates may not be identical
controlLocations = zeros(1, sum(controlList));
source = [1:30 1:30 randsample(1:30, 10, 1)];
seed = randi(length(source), 1);
controlLocations(1) = source(seed);
source(seed) = [];
for c = 2: sum(controlList)
    seed = randi(length(source), 1);
    if c <= 2
        while source(seed) == controlLocations(c-1)
            seed = randi(length(source), 1);
        end
    else
        while source(seed) == controlLocations(c-1) || source(seed) == controlLocations(c-2)
            seed = randi(length(source), 1);
        end
    end
    controlLocations(c) = source(seed);
    source(seed) = [];
end

controlSequence = cell(length(controlList)-1, 1);
for i = 2 : length(controlList)
    controlSequence{i-1} = controlLocations(sum(controlList(1:i-1))+1:sum(controlList(1:i)));
end
controlList = controlList(2:end);

save('controlSequence.mat', 'controlSequence', 'controlList')