function muscle = getMuscleFromCollection(obj, muscleName)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

    namesFull = {obj.muscles(:).nameShort};
    
    indexMuscleName = strcmp(namesFull, muscleName);
    
    muscle = obj.muscles(indexMuscleName);
    
end

