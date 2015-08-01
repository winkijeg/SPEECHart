function h = plot_landmarks(obj, names, col, h_axes, funcHandle)
% plot all (or a few) landmarks which were manually determined
    % this method plots landmarks only if the position is non-empty
    %    
    %input arguments:
    %
    %   - names     : CellString, i.e. {'ANS'}, {'ANS', 'PNS'}, or {} 
    %                 - use {'ANS'} for plotting just one landmark
    %                 - use {'ANS', 'PNS'} for plotting each landmark in the CellString
    %                   o possible values are: 'StyloidProcess', 'TongInsL', 
    %                     'TongInsH', 'ANS', 'PNS', 'VallSin', 'AlvRidge', 
    %                     'PharH', 'PharL', 'Palate', 'Lx', 'LipU', 'LipL', 
    %                     'TongTip', 'Velum' (see documentation for a description)
    %                 - leave empty ({}) in order to plot the full set of landmarks
    %   - col       : color, i.e. 'r' for red, or [1 0 0] ( RGB - triple )
    %   - h_axes    : axes handle of the window to be plotted to

    if ~exist('names', 'var') || isempty(names)
        
        fieldNamesStr = {'StyloidProcess', 'TongInsL', 'TongInsH', ...
            'ANS', 'PNS', 'VallSin', 'AlvRidge', 'PharH', 'PharL', ...
            'Palate', 'Lx', 'LipU', 'LipL', 'TongTip', 'Velum'};
        
    else
        
        fieldNamesStr = names;
    
    end
   
    if ~exist('col', 'var') || isempty(col)
        col = 'k';
    end

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = obj.initPlotFigure(false);
    end
    
    if ~exist('funcHandle', 'var') || isempty(funcHandle)
        funcHandle = '';
    end
    
   
    nLandmarks = size(fieldNamesStr, 2);
    for nbLandmark = 1:nLandmarks

        lab_tmp = fieldNamesStr{nbLandmark};
        ptTmp = obj.(['xy' fieldNamesStr{nbLandmark}]);
        
        if ~isempty(ptTmp)
            
            h(1, nbLandmark) = plot(h_axes, ptTmp(1), ptTmp(2), [col 'o'], ...
                'MarkerFaceColor', [0.75 0.75 0.75], 'Tag', fieldNamesStr{nbLandmark}, ...
                'ButtonDownFcn', funcHandle);
            h(2, nbLandmark) = text(ptTmp(1)+3, ptTmp(2)+3, lab_tmp, 'Color', 'w', 'Parent', h_axes);
        else
            h(1, nbLandmark) = NaN;
            h(2, nbLandmark) = NaN;
        end
        
    end

end
