function currentAxes = initPlotFigure(obj, imageFlag)
% initialize plot figure with regard to specific geometrical speaker data

% range of x and y values seen in the new pic
xDim = 165; % [mm]
yDim = xDim; % [mm]

% ipt prefs
iptsetpref('ImshowAxesVisible', 'Off')
iptsetpref('ImshowBorder', 'loose')

ptCenter = obj.landmarksDerivedGrid.circleMidpoint;
xlim = [ptCenter(1) - xDim/2 ptCenter(1) + xDim/2];
ylim = [ptCenter(2) - yDim/2 ptCenter(2) + yDim/2];

if imageFlag == true
    figure;
    imshow(obj.sliceData, 'XData', obj.xdataSlice, 'YData', obj.ydataSlice);
    currentAxes = gca;
    set(currentAxes, 'Color', [0 0 0], 'YDir', 'normal');
else
    figure;
    currentAxes = gca;
end

axis on;
axis equal;
hold on;

% adjust the visible part ----------------------------------------
set(gca, 'XLim', xlim, 'YLim', ylim)

% label the axes -------------------------------------------------
xlabel ('A -> P [mm]')
ylabel ('I -> S [mm]')

end
