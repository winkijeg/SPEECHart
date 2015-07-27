function [] = plot_contours_modelParts(obj, col, lineWidth, h_axes)
% plot parts of the two traces which are relevant for model design
    %
    %input arguments:
    %
    %   - col       : color, i.e. 'r' for red, or [1 0 0] ( RGB - triple )
    %   - lineWidth : line width / MATLAB standard line property
    %   - h_axes    : axes handle of the window to be plotted to
    %

    if ~exist('lineWidth', 'var') || isempty(lineWidth)
        lineWidth = 1;
    end

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = obj.initPlotFigure(false);
    end
    
    % plot tongue part
    plot(h_axes, obj.xyInnerTrace(1, obj.idxTongue(1):obj.idxTongue(2)), ...
        obj.xyInnerTrace(2, obj.idxTongue(1):obj.idxTongue(2)), col, 'lineWidth', lineWidth)
    
    % plot tongue-larynx part
    plot(h_axes, obj.xyInnerTrace(1, 1:obj.idxTongue(1)), ...
        obj.xyInnerTrace(2, 1:obj.idxTongue(1)), col, 'lineWidth', lineWidth)
    
    % plot back pharyngeal wall
    plot(h_axes, obj.xyOuterTrace(1, obj.idxPharynx(1):obj.idxPharynx(2)), ...
        obj.xyOuterTrace(2, obj.idxPharynx(1):obj.idxPharynx(2)), col, 'lineWidth', lineWidth)

    % plot back pharyngeal wall
    plot(h_axes, obj.xyOuterTrace(1, 1:obj.idxPharynx(1)), ...
        obj.xyOuterTrace(2, 1:obj.idxPharynx(1)), col, 'lineWidth', lineWidth)
    
    % plot velum
    plot(h_axes, obj.xyOuterTrace(1, obj.idxVelum(1):obj.idxVelum(2)), ...
        obj.xyOuterTrace(2, obj.idxVelum(1):obj.idxVelum(2)), col, 'lineWidth', lineWidth)
    
    % plot palate
    plot(h_axes, obj.xyOuterTrace(1, obj.idxPalate(1):obj.idxPalate(2)), ...
        obj.xyOuterTrace(2, obj.idxPalate(1):obj.idxPalate(2)), col, 'lineWidth', lineWidth)
    
 
end
