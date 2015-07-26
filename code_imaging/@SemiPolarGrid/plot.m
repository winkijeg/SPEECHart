function [] = plot(obj, col, grdLines, h_axes)
%visualize semi-polar grid of a specific speaker
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
        grdLines = 1:obj.nGridlines;
    end

    if ~exist('h_axes', 'var') || isempty(h_axes)
        figure;
        hold on;
        h_axes = gca;
    end

    nGrdLinesToPlot = length(grdLines);

    innerXval = obj.innerPt(1, grdLines(1):grdLines(end));
    outerXval = obj.outerPt(1, grdLines(1):grdLines(end));

    innerYval = obj.innerPt(2, grdLines(1):grdLines(end));
    outerYval = obj.outerPt(2, grdLines(1):grdLines(end));

    for nbGridLine = 1:nGrdLinesToPlot
    
        line([innerXval(nbGridLine) outerXval(nbGridLine)], ...
            [innerYval(nbGridLine) outerYval(nbGridLine)], ...
            'Color', col, 'Parent', h_axes);
    end

end
