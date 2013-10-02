% script 

clear *
close all

princInvestigator = 'PP';
speakerName = 'FF1';
phonLab = 'a';
scanOrient = 'm';

flagBspline = true;

if ~exist('path_root', 'var')
    [path_root, path_model, path_fList, path_seg] = ...
        initPaths(princInvestigator, speakerName);
end

% ------------------------------------------------------------------------

fn_speakerMat = [princInvestigator '_' speakerName '_' phonLab '.mat'];
mat = load([path_fList fn_speakerMat]);

mySpk = SpeakerImaging(mat);
mySpk = resampleMidSagittSlice(mySpk, 1, 1);

mySpk = determineMeasuresTongueShape(mySpk);

%plotMidSagittSlice(mySpk);
%mySpk = normalizeMidSagittSlice(mySpk);
figure
hold on
%plotMidSagittSlice(mySpk);

plotLandmarks(mySpk, 'm')
plotLandmarksDerived(mySpk, 'c')
plotMeasureMorphology(mySpk, 'ratioVH', 'r')
plotMeasureMorphology(mySpk, 'palateAngle', 'r')

%plotSemipolarGrid(mySpk, 'k')
plotContours(mySpk, ~flagBspline, 'r')
plotContours(mySpk, flagBspline, 'b')

plotSemipolarGrid(mySpk, 'r', 5:20)

% plot tongue shape measures
plotMeasureTongueShape(mySpk, 'curvatureInversRadius', 'm')
plotMeasureTongueShape(mySpk, 'quadCoeff', 'g')
plotMeasureTongueShape(mySpk, 'tongLength', 'k')

mySpk = determineMeasuresConstriction(mySpk);

plotMeasureConstriction(mySpk, 'relConstrHeight', 'k')
plotSemipolarGrid(mySpk, 'c', mySpk.semipolarGrid.indexBending)
