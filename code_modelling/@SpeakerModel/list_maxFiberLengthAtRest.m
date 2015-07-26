function [] = list_maxFiberLengthAtRest(obj)
%list the (maximum) fiber length for each muscle in model rest position

    nMuscles = obj.muscles.nMuscles;
    
    for nbMuscle = 1:nMuscles
        
        nameShortTmp = obj.muscles.muscleArray(nbMuscle).nameShort;
        nameLongTmp = obj.muscles.muscleArray(nbMuscle).nameLong;
        valTmp = obj.muscles.muscleArray(nbMuscle).fiberMaxLengthAtRest;
        
        lineTmp = sprintf('%s (%s): %4.1f mm', nameLongTmp, nameShortTmp, valTmp);
        disp(lineTmp);
        
    end
    
end

