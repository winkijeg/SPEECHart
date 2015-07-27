function [] = plot_contours(obj, col, h_axes)
% plot the two traces whis were manually determined
    %    
    %input arguments:
    %
    %   - col       : color, i.e. 'r' for red, or [1 0 0] ( RGB - triple )
    %   - h_axes    : axes handle of the window to be plotted to
    %

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = obj.initPlotFigure(false);
    end
        
    plot(h_axes, obj.xyInnerTrace(1, :), obj.xyInnerTrace(2, :), col)
   
    plot(h_axes, obj.xyOuterTrace(1, :), obj.xyOuterTrace(2, :), col)

end
