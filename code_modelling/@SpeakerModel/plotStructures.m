function [] = plotStructures(obj, col)
% plot rigid structures of the vocal tract model

    def_structures = {'upperIncisorPalate', 'velum', ...
        'backPharyngealWall'};

    structNames = def_structures;
    numberOfStructs = length(structNames);
    
    for k = 1:numberOfStructs
        
        ptTmp = obj.structures.(structNames{k});
        plot(ptTmp(1, :), ptTmp(2, :), col)
        
    end
    
end

