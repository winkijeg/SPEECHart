function [] = plot_contours(obj, names, col, h_axes)
% plot contour of a single structures of the vocal tract model

    if ~exist('names', 'var') || isempty(names)
        names = fieldnames(obj.structures)';
    end

    if ~exist('col', 'var') || isempty(col)
        col = 'k';
    end

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = obj.initPlotFigure(false);
    end

    % plot the structures ...................................
    nContours = size(names, 2);
    for nbContour = 1:nContours
        
        ptTmp = obj.structures.(names{nbContour});
        plot(h_axes, ptTmp(1, :), ptTmp(2, :), col);
        
    end
    
end

