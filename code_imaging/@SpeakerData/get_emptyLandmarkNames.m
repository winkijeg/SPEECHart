function outStrings = get_emptyLandmarkNames( obj )
%return names of landmarks with empty position data

    fieldNamesStr = {'StyloidProcess', 'TongInsL', 'TongInsH', ...
        'ANS', 'PNS', 'VallSin', 'AlvRidge', 'PharH', 'PharL', ...
        'Palate', 'Lx', 'LipU', 'LipL', 'TongTip', 'Velum'};
    
    nLandmarks = size(fieldNamesStr, 2);
    for nbLandmark = 1:nLandmarks
        
        if sum(isnan(obj.(['xy' fieldNamesStr{nbLandmark}]))) > 0
            
            cellStrTmp{nbLandmark} = fieldNamesStr{nbLandmark};
        
        else
            
            cellStrTmp{nbLandmark} = '';
            
        end
        
    end
    
    % remove empty cells
    cellStrTmp(strcmp(cellStrTmp, '')) = [];
    
    if (isempty(cellStrTmp))
        outStrings = {'no landmark left'};
    else
        outStrings = cellStrTmp;
    end
    
end

