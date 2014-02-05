function fiberLengths = determineFiberLength(obj, tongueMesh)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    nFibers = obj.nFibers;
    
    fiberLengths = nan(1, nFibers);
    for nbFiber = 1:nFibers
        
        indEmpty = cellfun(@isempty, obj.fiberFixpoints(nbFiber, :));
        valuesNonEmpty = obj.fiberFixpoints(nbFiber, ~indEmpty);
        
        nFixpoints = size(valuesNonEmpty, 2);
        
        fixpointPos = nan(2, nFixpoints);
        for nbFixpoint = 1:nFixpoints
            
            if ischar(valuesNonEmpty{nbFixpoint})
                
                fixpointPos(1:2, nbFixpoint) = ...
                    obj.externalInsertionPointPosition.(valuesNonEmpty{nbFixpoint});
            else
                
                fixpointPos(1:2, nbFixpoint) = ...
                    getPositionOfNodeNumbers(tongueMesh, valuesNonEmpty{nbFixpoint});
            end
            
        end
        
        fiberLengths(1, nbFiber) = polyline_length_nd(2, nFixpoints, fixpointPos);
        
    end



end

