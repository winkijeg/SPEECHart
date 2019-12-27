function [] = plot_grid ( obj, col, grdLines, h_axes )
%plot full semi-polar grid associated with the specific speaker
    %    
    %input arguments:
    %
    %   - col       : color
    %   - grdLines  : integer, i.e. 2, 2:20, or [] 
    %                 - use 2 for plotting the 12th gridline
    %                 - use 2:20 for plotting each line from 2 to 20
    %                 - leave empty ([]) in order to plot the full grid
    %   - h_axes    : axes handle of the window to be plotted to 

    if ~exist('grdLines', 'var') || isempty(grdLines)
        grdLines = 1:obj.grid.nGridlines;
    end

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = obj.initPlotFigure(false);
    end

    
    obj.grid.plot(col, grdLines, h_axes);

end

