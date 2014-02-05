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

% load structure that has been created before
fn_speakerMat = [princInvestigator '_' speakerName '_' phonLab '.mat'];
mat = load([pathImaging fn_speakerMat]);

% create SpeakerImaging object
mySpk = SpeakerImaging(mat);

mySpk = resampleMidSagittSlice(mySpk, 0.25, 0.25);
mySpk = normalizeMidSagittSlice(mySpk);







initPlotFigure(mySpk, imgFlag);

plotLandmarks(mySpk, 'm')
plotLandmarksDerived(mySpk, 'c')
plotMeasureMorphology(mySpk, 'ratioVH', 'r')
plotMeasureMorphology(mySpk, 'palateAngle', 'r')

%plotSemipolarGrid(mySpk, 'k')
plotContours(mySpk, ~flagBspline, 'r')
plotContours(mySpk, flagBspline, 'b')

plotSemipolarGrid(mySpk, 'r', 5:20)

% plot tongue shape measures if phoneme is /a/
if strcmp(phonLab, 'a')
    
    mySpk = determineMeasuresTongueShape(mySpk);
    
    plotMeasureTongueShape(mySpk, 'curvatureInversRadius', 'm')
    plotMeasureTongueShape(mySpk, 'quadCoeff', 'g')
    plotMeasureTongueShape(mySpk, 'tongLength', 'k')
    
    mySpk = determineMeasuresConstriction(mySpk);
    
    plotMeasureConstriction(mySpk, 'relConstrHeight', 'k')
    plotSemipolarGrid(mySpk, 'c', mySpk.semipolarGrid.indexBending)
end
