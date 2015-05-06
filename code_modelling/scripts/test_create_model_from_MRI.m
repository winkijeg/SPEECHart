% creates an adapted model based on measurements on mad-sagittal MRI slice

clearvars
close all

princInvestigator = 'PP';
speakerName = 'FM1';
phonLab = '@';

speakerID_out = 'cs';

% specify path names
[path_root, ~, pathImaging] = ...
    initPaths(princInvestigator, speakerName);

path_out = [path_root 'data/models_obsolete/' speakerID_out '/'];

% read and construct the generic model object
strucGeneric = load([path_root 'code_modelling\@ModelProducer\ypm_model.mat']);
modelGeneric = SpeakerModel(strucGeneric);

% read in raw speaker specification (landmarks and images)
strucImagingIn = formatRawDataToSpeakerImaging( pathImaging, princInvestigator, ...
    speakerName, phonLab );

% create SpeakerImaging object
mySpkImg = SpeakerImaging(strucImagingIn);
[dataSpkMRI, gridZoning] = extractDataForModelCreation(mySpkImg);

% create modelFactory-object
myModelProducer = ModelProducer(dataSpkMRI, gridZoning);
modelData = matchModel(myModelProducer);

% create the model object
myModel = SpeakerModel(modelData);

% plotting ............................................................
figure
initPlotFigure(myModel, true)

plotStructures(modelGeneric, 'k--')
plotLandmarks(modelGeneric, 'k')
drawTongSurface(modelGeneric.tongGrid, 'r')
%plotTongueMesh(modelGeneric, 'k')

initPlotFigure(myModel, true)
plotLandmarks(myModel, 'b')
plotStructures(myModel, 'b')
drawTongSurface(myModel.tongGrid, 'r')
%plotTongueMesh(mySpkModel, 'r')


% save model data (mat-file-format)
fn_out_model = [path_out speakerID_out '_model.mat'];

% save(fn_out_model, '-struct', 'modelData')
save(fn_out_model, 'myModel')

% convert Model into obsolete format to simulate with the original code
matsOut = exportModelObsolete(myModel);

data_palais_repos = matsOut.data_palais_repos;
result_stocke = matsOut.result_stocke;
XY_repos = matsOut.XY_repos;

fn_out_palais_repos = [path_out 'data_palais_repos_' speakerID_out '.mat'];
fn_result_stocke = [path_out 'result_stocke_' speakerID_out '.mat'];
fn_XY_repos = [path_out 'XY_repos_' speakerID_out '.mat'];

save(fn_out_palais_repos, '-struct','data_palais_repos');
save(fn_result_stocke, '-struct', 'result_stocke');
save(fn_XY_repos, '-struct', 'XY_repos');


