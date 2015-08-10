function [] = plot_landmarks_derived(obj, col, h_axes)
%plot derived landmarks necessary for grid generation
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
        h_axes = gca;
    end

    fieldNamesStr = fieldnames(obj.derivedPoints);
    nLandmarks = size(fieldNamesStr, 1);

    for k = 1:nLandmarks

        lab_tmp = fieldNamesStr{k};
        ptTmp = obj.derivedPoints.(fieldNamesStr{k})';

        plot(h_axes, ptTmp(1), ptTmp(2), [col 'o'], 'MarkerFaceColor', [0.75 0.75 0.75])
        text(ptTmp(1)+3, ptTmp(2)+3, lab_tmp, 'Color', col, ...
            'Parent', h_axes, 'FontAngle', 'italic')

    end



end

