function [] = plot_landmarks_derived( obj, col, h_axes )
% plot all derived landmarks stored in the SpeakerData object

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = obj.initPlotFigure(false);
    end

    fieldNamesStr = fieldnames(obj.landmarksDerived);
    nLandmarks = size(fieldNamesStr, 1);

    for k = 1:nLandmarks

        lab_tmp = fieldNamesStr{k};
        ptTmp = obj.landmarksDerived.(fieldNamesStr{k})';

        plot(h_axes, ptTmp(1), ptTmp(2), [col 'o'], 'MarkerFaceColor', col)
        text(ptTmp(1)+3, ptTmp(2)+3, lab_tmp, 'Color', col, 'Parent', h_axes)

    end

end
