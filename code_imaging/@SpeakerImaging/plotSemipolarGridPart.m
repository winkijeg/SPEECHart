function [] = plotSemipolarGridPart(obj, col, grdLines, cAxes)
% plot partially semipolar grid specified by the third argument
%   i.e. 3:7 or only one gridline (i.e. 10)

if nargin == 3
    % create new figure
    cAxes = initPlotFigure(obj, false);
end

nGrdLinesToPlot = length(grdLines);

innerXval = obj.semipolarGrid.innerPt(1, grdLines(1):grdLines(end));
outerXval = obj.semipolarGrid.outerPt(1, grdLines(1):grdLines(end));

innerYval = obj.semipolarGrid.innerPt(2, grdLines(1):grdLines(end));
outerYval = obj.semipolarGrid.outerPt(2, grdLines(1):grdLines(end));

for k = 1:nGrdLinesToPlot
    
    line([innerXval(k) outerXval(k)], ...
        [innerYval(k) outerYval(k)], 'Color', col, 'Parent', cAxes)
    
end

end
