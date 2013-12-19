% script 

clearvars
close all

princInvestigator = 'PP';
speakerName = 'FF1';
phonLab = '@';

flagBspline = true;

imgFlag = true; %false;

[~, ~, pathImaging] = ...
    initPaths(princInvestigator, speakerName);

% ------------------------------------------------------------------------

fn_speakerMat = [princInvestigator '_' speakerName '_' phonLab '.mat'];
mat = load([pathImaging fn_speakerMat]);

mySpk = SpeakerImaging(mat);

mySpk = resampleMidSagittSlice(mySpk, 1, 1);


if strcmp(phonLab, 'a')
    mySpk = determineMeasuresTongueShape(mySpk);
end

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

% plot tongue shape measures
if strcmp(phonLab, 'a')
    plotMeasureTongueShape(mySpk, 'curvatureInversRadius', 'm')
    plotMeasureTongueShape(mySpk, 'quadCoeff', 'g')
    plotMeasureTongueShape(mySpk, 'tongLength', 'k')

    mySpk = determineMeasuresConstriction(mySpk);

    plotMeasureConstriction(mySpk, 'relConstrHeight', 'k')
    plotSemipolarGrid(mySpk, 'c', mySpk.semipolarGrid.indexBending)
end
