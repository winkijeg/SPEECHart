function h = plot_contours(obj, names, col, h_axes)
% plot contour(s) of anatomical structures of the VT model
    %    
    %input arguments:
    %
    %   - names     : CellString, i.e. {'backPharyngealWall'} or {} 
    %                 - use {'backPharyngealWall'} for plotting just one structure
    %                 - use {'upperLip', 'velum'} for plotting each structure in the CellString
    %                   o possible values are: 'upperLip', 'upperIncisorPalate', 
    %                     'velum', 'backPharyngealWall', 'larynxArytenoid',
    %                     'tongueLarynx', 'lowerIncisor', 'lowerLip'
    %                 - leave empty ({}) to plot all structures at once
    %   - col       : color, i.e. 'r' for red, or [1 0 0] ( RGB - triple )
    %   - h_axes    : axes handle of the window to be plotted to
    %
    
    if ~exist('names', 'var') || isempty(names)
        names = fieldnames(obj.structures)';
    end

    if ~exist('col', 'var') || isempty(col)
        col = 'k';
    end

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = obj.initPlotFigure(false);
    end

    nContours = size(names, 2);
    for nbContour = 1:nContours
        
        ptTmp = obj.structures.(names{nbContour});
        h(nbContour) = plot(h_axes, ptTmp(1, :), ptTmp(2, :), col);
        
    end
    
end

