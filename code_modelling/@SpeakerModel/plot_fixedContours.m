function h = plot_fixedContours(obj, col, h_axes)
% plot all RIGID anatomical structures of the VT model

    if ~exist('col', 'var') || isempty(col)
        col = 'k';
    end

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = obj.initPlotFigure(false);
    end
    
    names = {'upperIncisorPalate', 'velum', 'backPharyngealWall'};

    h = plot_contours(obj, names, col, h_axes);
    
end

