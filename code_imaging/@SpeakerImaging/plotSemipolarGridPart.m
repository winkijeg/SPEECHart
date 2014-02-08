function [] = plotSemipolarGridPart(obj, col, nbsOfGrdLines, cAxes)
% plot partially semipolar grid specified by the third argument
%   i.e. 3:7 or only one gridline (i.e. 10)

if nargin == 3
    % create new figure
    cAxes = initPlotFigure(obj, false);
end

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
