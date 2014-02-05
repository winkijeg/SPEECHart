function [] = plotStructures(obj, col)

    structNames = fieldnames(obj.structures);
    numberOfStructs = length(structNames);
    
    for k = 1:numberOfStructs
        
        ptTmp = obj.structures.(structNames{k});
        
        plot(ptTmp(1, :), ptTmp(2, :), col)
    end
    
end

