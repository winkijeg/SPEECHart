function outStrings = get_emptyTraceNames( obj )
%return names of landmarks with empty position data

    fieldNamesStr = {'InnerTrace_raw', 'OuterTrace_raw'};
    
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

