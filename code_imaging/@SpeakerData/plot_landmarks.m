function [] = plot_landmarks(obj, landmarks, col, h_axes)
% plot all (or a few) landmarks which were manually determined
    %    
    %input arguments:
    %
    %   - col       : color, i.e. 'r' for red, or [1 0 0] ( RGB - triple )
    %   - landmarks : CellString, i.e. {'ANS'}, {'ANS', 'PNS'}, or {} 
    %                 - use {'ANS'} for plotting just one landmark
    %                 - use {'ANS', 'PNS'} for plotting each landmark in the CellString
    %                   o possible values are: 'StyloidProcess', 'TongInsL', 
    %                     'TongInsH', 'ANS', 'PNS', 'VallSin', 'AlvRidge', 
    %                     'PharH', 'PharL', 'Palate', 'Lx', 'LipU', 'LipL', 
    %                     'TongTip', 'Velum' (see documentation for a description)
    %                 - leave empty ({}) in order to plot the full set of landmarks
    %   - h_axes    : axes handle of the window to be plotted to

    if ~exist('landmarks', 'var') || isempty(landmarks)
        
        fieldNamesStr = {'StyloidProcess', 'TongInsL', 'TongInsH', ...
            'ANS', 'PNS', 'VallSin', 'AlvRidge', 'PharH', 'PharL', ...
            'Palate', 'Lx', 'LipU', 'LipL', 'TongTip', 'Velum'};
        
    else
        
        fieldNamesStr = landmarks;
    
    end
   
    if ~exist('col', 'var') || isempty(col)
        col = 'k';
    end

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = obj.initPlotFigure(false);
    end
    
   
    nLandmarks = size(fieldNamesStr, 2);

    for nbLandmark = 1:nLandmarks

        lab_tmp = fieldNamesStr{nbLandmark};
        ptTmp = obj.(['xy' fieldNamesStr{nbLandmark}]);

        plot(h_axes, ptTmp(1), ptTmp(2), [col 'o'], 'MarkerFaceColor', col)
        text(ptTmp(1)+3, ptTmp(2)+3, lab_tmp, 'Color', col, 'Parent', h_axes)

    end

end
