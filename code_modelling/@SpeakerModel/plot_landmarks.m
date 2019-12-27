function h = plot_landmarks(obj, names, col, h_axes)
% plot all (or a few) landmarks relevant to the VT model
    %    
    %input arguments:
    %
    %   - names     : CellString, i.e. {'ANS'}, {'ANS', 'PNS'}, or {} 
    %                 - use {'ANS'} for plotting just one landmark
    %                 - use {'ANS', 'PNS'} for plotting each landmark in the CellString
    %                   o possible values are: 'StyloidProcess', 'Condyle',  
    %                     'ANS', 'PNS', 'HyoA', 'HyoB', 'HyoC', 'Origin',
    %                     'TongInsL', 'TongInsH'
    %                 - leave empty ({}) in order to plot the full set of landmarks
    %   - col       : color, i.e. 'r' for red, or [1 0 0] ( RGB - triple )
    %   - h_axes    : axes handle of the window to be plotted to

    if ~exist('names', 'var') || isempty(names)
        
        fieldNamesStr = {'StyloidProcess', 'Condyle', 'ANS', 'PNS', ...
            'HyoA', 'HyoB', 'HyoC', 'Origin', 'TongInsL', 'TongInsH'};
        nLandmarks = size(fieldNamesStr, 2);
        
    else
        fieldNamesStr = names;
        nLandmarks = size(fieldNamesStr, 2);
    end

    if ~exist('col', 'var') || isempty(col)
        col = 'k';
    end
    

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = obj.initPlotFigure(false);
    end
    
    
    
    for nbLandmark = 1:nLandmarks

        lab_tmp = fieldNamesStr{nbLandmark};
        ptTmp = obj.landmarks.(['xy' lab_tmp])';
    
        h(nbLandmark) = plot(h_axes, ptTmp(1), ptTmp(2), [col 'o'], 'MarkerFaceColor', col);
        text(ptTmp(1)+3, ptTmp(2)+3, lab_tmp, 'Color', col, 'Parent', h_axes);
    
    end

end
