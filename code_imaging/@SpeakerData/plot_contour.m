function h = plot_contour(obj, contName, col, h_axes, funcHandle)
% plot the two traces which were manually determined
    %    
    %input arguments:
    %
    %   - col       : color, i.e. 'r' for red, or [1 0 0] ( RGB - triple )
    %   - h_axes    : axes handle of the window to be plotted to
    %
 
    if ~exist('col', 'var') || isempty(col)
        col = 'k';
    end

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = obj.initPlotFigure(false);
    end
    
    modus = 'edit';
    if ~exist('funcHandle', 'var') || isempty(funcHandle)
        funcHandle = '';
        modus = 'plain';
    end
    
    
    switch contName
        case 'inner'
            xValsTmp = obj.xyInnerTrace(1, :);
            yValsTmp = obj.xyInnerTrace(2, :);
        case 'outer'
            xValsTmp = obj.xyOuterTrace(1, :);
            yValsTmp = obj.xyOuterTrace(2, :);
    end
 
    
    switch modus
        case 'plain'
            h = plot(h_axes, xValsTmp, yValsTmp, 'w-');
        case 'edit'
            nPoints = size(xValsTmp, 2);
            for nbPoint = 1:nPoints
                h(nbPoint) = plot(h_axes, xValsTmp(nbPoint), yValsTmp(nbPoint), ...
                    [col 'o'], 'MarkerFaceColor', [0.75 0.75 0.75], ...
                    'Tag', int2str(nbPoint), 'ButtonDownFcn', funcHandle);
            end
    end
            
    
end
