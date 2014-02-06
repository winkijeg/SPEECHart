function [] = plotSemipolarGridFull(obj, col, cAxes)
% plot full semipolar grid stored in the SpeakerImaging object

if nargin == 2
    % create new figure
    cAxes = initPlotFigure(obj, false);
end

nbsOfGrdLines = 1:obj.semipolarGrid.numberOfGridlines;
nGrdLinesToPlot = length(nbsOfGrdLines);

innerXval = obj.semipolarGrid.innerPt(1, nbsOfGrdLines(1):nbsOfGrdLines(end));
outerXval = obj.semipolarGrid.outerPt(1, nbsOfGrdLines(1):nbsOfGrdLines(end));

innerYval = obj.semipolarGrid.innerPt(2, nbsOfGrdLines(1):nbsOfGrdLines(end));
outerYval = obj.semipolarGrid.outerPt(2, nbsOfGrdLines(1):nbsOfGrdLines(end));

for k = 1:nGrdLinesToPlot
    
    line([innerXval(k) outerXval(k)], ...
        [innerYval(k) outerYval(k)], 'Color', col, 'Parent', cAxes)
    
end

end
