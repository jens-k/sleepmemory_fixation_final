% controlList = [0, 4, 6, 7, 3, 5, 6, 4, 6, 3, 4, 6, 4, 5, 7];
controlList = [0, 4, 7, 3, 5, 6, 4, 6, 3, 4, 6, 5, 7];

% create coordinates for cards that change color in the control task, while
% 2 succeeding coordinates may not be identical
controlLocations = zeros(1, sum(controlList));
% source = [1:30 1:30 randsample(1:30, 10, 1)];
source = [1:30 1:30];
seed = randi(length(source), 1);
controlLocations(1) = source(seed);
source(seed) = [];
for c = 2: sum(controlList)
    seed = randi(length(source), 1);
    switch controlLocations(c-1)
        case {1, 7, 13, 19, 25}
            neighbourhood = [ ...
                controlLocations(c-1)-6 controlLocations(c-1)-5 ...
                controlLocations(c-1) controlLocations(c-1)+1 ...
                controlLocations(c-1)+6 controlLocations(c-1)+7 ...
                ];
        case {6, 12, 18, 24, 30}
            neighbourhood = [ ...
                controlLocations(c-1)-7 controlLocations(c-1)-6 ...
                controlLocations(c-1)-1 controlLocations(c-1) ...
                controlLocations(c-1)+5 controlLocations(c-1)+6 ...
                ];
        otherwise
            neighbourhood = [ ...
                controlLocations(c-1)-7 controlLocations(c-1)-6 controlLocations(c-1)-5 ...
                controlLocations(c-1)-1 controlLocations(c-1) controlLocations(c-1)+1 ...
                controlLocations(c-1)+5 controlLocations(c-1)+6 controlLocations(c-1)+7 ...
                ];
    end
    neighbourhood = neighbourhood(neighbourhood>0 & neighbourhood<=30);
    if c <= 2
        % avoid subsequent adjacent positions
        while ismember(source(seed), neighbourhood)
            seed = randi(length(source), 1);
        end
    else
        % avoid direct repetitions (ABA)
        while ismember(source(seed), neighbourhood) || source(seed) == controlLocations(c-2)
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