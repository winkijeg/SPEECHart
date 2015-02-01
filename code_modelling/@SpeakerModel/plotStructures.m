function [] = plotStructures(obj, col)
% plot rigid structures

    def_structures = {'upperIncisorPalate', 'velum', ...
        'backPharyngealWall', 'tongueLarynx'};

    structNames = def_structures;
    numberOfStructs = length(structNames);
    
    for k = 1:numberOfStructs
        
        
        
        % to be removed in the future ...........
        if (strcmp(structNames{k}, 'upperIncisorPalate'))
            ptTmp = obj.structures.(structNames{k})(1:2, 8:end);
        else
            ptTmp = obj.structures.(structNames{k});
        end
        
        plot(ptTmp(1, :), ptTmp(2, :), col)
    end
    
end

