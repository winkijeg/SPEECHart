function outStrings = get_emptyTraceNames( obj )
%return names of landmarks with empty position data

    fieldNamesStr = {'InnerTrace', 'OuterTrace'};
    
    nLandmarks = size(fieldNamesStr, 2);
    for nbTraces = 1:nLandmarks
        
        if isnan(obj.(['xy' fieldNamesStr{nbTraces}]))
            
            cellStrTmp{nbTraces} = fieldNamesStr{nbTraces};
        
        else
            
            cellStrTmp{nbTraces} = '';
            
        end
        
        
    end
    
    % remove empty cells
    cellStrTmp(strcmp(cellStrTmp, '')) = [];
    
    if (isempty(cellStrTmp))
        outStrings = {'no trace left'};
    else
        outStrings = cellStrTmp;
    end
    
end

