% read prepared data, create the object and plot (some) features

clearvars
close all

% speaker specification, coded in the filename as PP_FF1_a[.ext]

princInvestigator = 'PP';
speakerName = 'FF1';
phonLab = 'a';

% flag: true means contour spline interpolation, false uses raw contour data
flagBspline = true;

% flag: true means usage of a midsagittal image, fals means plots only
imgFlag = true; %false;

% create path names
[~, ~, pathImaging] = ...
    initPaths(princInvestigator, speakerName);

% read in raw speaker specification (landmarks and images)
struc = formatRawDataToSpeakerImaging( pathImaging, princInvestigator, ...
    speakerName, phonLab );

% create SpeakerImaging object
mySpk = SpeakerImaging(struc);

mySpk = resampleMidSagittSlice(mySpk, 0.25, 0.25);
mySpk = normalizeMidSagittSlice(mySpk);

cAxesImg = initPlotFigure(mySpk, imgFlag);
cAxesBlank = initPlotFigure(mySpk, false);
cAxes3 = initPlotFigure(mySpk, true);
cAxes4 = initPlotFigure(mySpk, true);

plotLandmarks(mySpk, 'm', cAxesImg)
plotContours(mySpk, ~flagBspline, 'r', cAxesImg)
plotContours(mySpk, flagBspline, 'b', cAxesImg)
plotLandmarksDerived(mySpk, 'c', cAxesImg)

plotSemipolarGridFull(mySpk, 'k', cAxesBlank)
plotSemipolarGridPart(mySpk, 'g', 5:20, cAxesBlank)
plotSemipolarGridPart(mySpk, 'r', mySpk.semipolarGrid.indexBending, cAxesBlank)

plotMeasureMorphology(mySpk, 'ratioVH', 'r', cAxes3)
plotMeasureMorphology(mySpk, 'palateAngle', 'y', cAxes3)


% constriction measures specific to /a/
mySpk = determineMeasuresConstriction(mySpk);
plotMeasureConstriction(mySpk, 'relConstrHeight', 'r', cAxesImg)

% tongue shape measures specific to /a/
mySpk = determineMeasuresTongueShape(mySpk);
plotMeasureTongueShape(mySpk, 'curvatureInversRadius', 'm', cAxes4)
plotMeasureTongueShape(mySpk, 'quadCoeff', 'g', cAxes4)
plotMeasureTongueShape(mySpk, 'tongLength', 'r', cAxes4)
    
