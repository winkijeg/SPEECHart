function [] = plot_grid ( obj, col, grdLines, h_axes )
%plot data related to a SpeakerData

    if ~exist('grdLines', 'var') || isempty(grdLines)
        grdLines = 1:obj.grid.nGridlines;
    end

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = obj.initPlotFigure(false);
    end

    
    obj.grid.plot(col, grdLines, h_axes);


end

