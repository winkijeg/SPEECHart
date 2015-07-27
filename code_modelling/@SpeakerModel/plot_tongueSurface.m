function [] = plot_tongueSurface( obj, col, h_axes )
%plot tongue surface of the VT model at tongue rest position
    %    
    %input arguments:
    %
    %   - col       : color, i.e. 'r' for red, or [1 0 0] ( RGB - triple )
    %   - h_axes    : axes handle of the window to be plotted to 



    if ~exist('col', 'var') || isempty(col)
        col = 'k';
    end

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = obj.initPlotFigure(false);
    end

    obj.tongue.drawTongSurface(col, h_axes);

end

