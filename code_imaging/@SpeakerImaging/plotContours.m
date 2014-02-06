function [] = plotContours(obj, flagBspline, col, cAxes)
% plot inner and outer VT contour stored in the SpeakerImaging object

if nargin == 3
    % create new figure
    cAxes = initPlotFigure(obj, false);
end

if flagBspline == true
    ptsContInner = obj.filteredContours.innerPt(1:2, :);
    ptsContOuter = obj.filteredContours.outerPt(1:2, :);
else
    ptsContInner = obj.contours.innerPt(1:2, :);
    ptsContOuter = obj.contours.outerPt(1:2, :);
end

plot(cAxes, ptsContInner(1, :), ptsContInner(2, :), col)
plot(cAxes, ptsContOuter(1, :), ptsContOuter(2, :), col)

end
