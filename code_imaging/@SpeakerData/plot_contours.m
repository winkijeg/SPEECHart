function [] = plot_contours(obj, col, h_axes)
% plot inner and outer VT contour manually determined

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = obj.initPlotFigure(false);
    end
        
    plot(h_axes, obj.xyInnerTrace(1, :), obj.xyInnerTrace(2, :), col)
   
    plot(h_axes, obj.xyOuterTrace(1, :), obj.xyOuterTrace(2, :), col)

end
