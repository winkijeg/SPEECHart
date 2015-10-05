function fiberLengths = determineFiberLength(obj, tonguePosFrame)
%determine muscle fiber length at a given time frame (PositionFrame)

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
                    getPositionOfNodeNumbers(tonguePosFrame, valuesNonEmpty{nbFixpoint});
            end
            
        end
        
        % fiberLengths(1, nbFiber) = polyline_length_nd(2, nFixpoints, fixpointPos);
        fiberLengths(1, nbFiber) = 0;
        for nbPoint = nFixpoints:-1:2
            
            fiberLengths(1, nbFiber) = fiberLengths(1, nbFiber) + ...
                sqrt( (fixpointPos(1, nbPoint)-fixpointPos(1, nbPoint-1))^2 ...
                + (fixpointPos(2, nbPoint)-fixpointPos(2, nbPoint-1))^2);
            
        end
            
    end

end

