function [] = plotLandmarks(obj, col, cAxes)
% plot all geometrical landmarks stored in the SpeakerImaging object

if nargin == 2
    % create new figure
    cAxes = initPlotFigure(obj, false);
end

fieldNamesStr = fieldnames(obj.landmarks);
nLandmarks = size(fieldNamesStr, 1);

for k = 1:nLandmarks
    
    lab_tmp = fieldNamesStr{k};
    ptTmp = obj.landmarks.(fieldNamesStr{k})';
        
    plot(cAxes, ptTmp(1), ptTmp(2), [col 'o'], 'MarkerFaceColor', col)
    text(ptTmp(1)+3, ptTmp(2)+3, lab_tmp, 'Color', col, 'Parent', cAxes)
    
end

end
