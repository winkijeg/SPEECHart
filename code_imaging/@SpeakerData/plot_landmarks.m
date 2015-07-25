function [] = plot_landmarks(obj, landmarks, col, h_axes)
% plot all geometrical landmarks stored in the SpeakerData object

    if ~exist('landmarks', 'var') || isempty(landmarks)
        
        fieldNamesStr = {'xyStyloidProcess', 'xyTongInsL', 'xyTongInsH', ...
            'xyANS', 'xyPNS', 'xyVallSin', 'xyAlvRidge', 'xyPharH', 'xyPharL', ...
            'xyPalate', 'xyLx', 'xyLipU', 'xyLipL', 'xyTongTip', 'xyVelum'};
        
    else
        
        fieldNamesStr = landmarks;
    
    end
   
    if ~exist('col', 'var') || isempty(col)
        col = 'k';
    end

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = obj.initPlotFigure(false);
    end
    
   
    nLandmarks = size(fieldNamesStr, 2);

    for nbLandmark = 1:nLandmarks

        lab_tmp = fieldNamesStr{nbLandmark}(3:end);
        ptTmp = obj.(fieldNamesStr{nbLandmark});

        plot(h_axes, ptTmp(1), ptTmp(2), [col 'o'], 'MarkerFaceColor', col)
        text(ptTmp(1)+3, ptTmp(2)+3, lab_tmp, 'Color', col, 'Parent', h_axes)

    end

end
