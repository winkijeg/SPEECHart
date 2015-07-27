function [] = plot_landmarks_derived( obj, col, h_axes )
% plot all landmarks which were derived from manyally determined landmarks
    %    
    %input arguments:
    %
    %   - col       : color, i.e. 'r' for red, or [1 0 0] ( RGB - triple )
    %   - h_axes    : axes handle of the window to be plotted to
    %
    
    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = obj.initPlotFigure(false);
    end

    fieldNamesStr = fieldnames(obj.landmarksDerived);
    nLandmarks = size(fieldNamesStr, 1);

    for k = 1:nLandmarks

        lab_tmp = fieldNamesStr{k}(3:end);
        ptTmp = obj.landmarksDerived.(fieldNamesStr{k})';

        plot(h_axes, ptTmp(1), ptTmp(2), [col 'o'], 'MarkerFaceColor', col)
        text(ptTmp(1)+3, ptTmp(2)+3, lab_tmp, 'Color', col, 'Parent', h_axes)

    end

end
