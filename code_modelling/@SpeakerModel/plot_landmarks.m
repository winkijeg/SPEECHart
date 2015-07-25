function [] = plot_landmarks(obj,landmarks, col, h_axes)
% plot all geometrical landmarks of a SpeakerModell object

    if ~exist('landmarks', 'var') || isempty(landmarks)
        
        fieldNamesStr = fieldnames(obj.landmarks);
        nLandmarks = size(fieldNamesStr, 1);
        
    else
        fieldNamesStr = landmarks;
        nLandmarks = size(fieldNamesStr, 2);
    end

    if ~exist('col', 'var') || isempty(col)
        col = 'k';
    end
    

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = obj.initPlotFigure(false);
    end
    
    
    
    for nbLandmark = 1:nLandmarks

        lab_tmp = fieldNamesStr{nbLandmark}(3:end);
        ptTmp = obj.landmarks.(['xy' lab_tmp])';
    
        plot(h_axes, ptTmp(1), ptTmp(2), [col 'o'], 'MarkerFaceColor', col);
        text(ptTmp(1)+3, ptTmp(2)+3, lab_tmp, 'Color', col, 'Parent', h_axes);
    
    end

end
