function muscle = getMuscleFromCollection(obj, muscleName)
%extract a single muscle from the full set of muscles

    namesFull = obj.names;
    
    idxMuscleName = strcmp(namesFull, muscleName);
    
    muscle = obj.muscleArray(idxMuscleName);
    
end

