% creates an adapted model based on measurements on mad-sagittal MRI slice

clearvars

princInvestigator = 'PP';
spkName = 'FF1';

% specify path names
[path_root, ~, path_mri] = ...
    initPaths(princInvestigator, spkName);
path_mat_modelGeneric = [path_root 'data/models_obsolete/ypm/'];


% load generic Model (matrix format)
matModelGeneric = load([path_mat_modelGeneric 'ypm_model.mat']);

% create modelFactory-object
myModelFactory = ModelFactory(matModelGeneric);

% construct matrix that fits the needs of matching ---------------------------- 
% load speaker data measured on mid-sagittal MRI slice 
matSpeakerMeasuresMRI = load([path_mri princInvestigator '_' spkName '_@.mat']);
mySpeakerImaging = SpeakerImaging(matSpeakerMeasuresMRI);
matRawModelTarget = convertToRawModelFormat(mySpeakerImaging);

matModelTarget = matching2D_ForRefactoring(myModelFactory, matRawModelTarget);

modelTarget = SpeakerModel(matModelTarget);

figure
modelTarget.initPlotFigure(true)
modelTarget.plotLandmarks('r')
modelTarget.plotStructures('b')
modelTarget.plotTongueMesh('k')


drawTongSurface(modelTarget.tongGrid, 'r')



% convert Model into obsolete format to simulate with the original code
matsOut = exportModelObsolete(modelTarget);

data_palais_repos = matsOut.data_palais_repos;
result_stocke = matsOut.result_stocke;
XY_repos = matsOut.XY_repos;

save('data_palais_repos_pp_FF1Refact.mat', '-struct','data_palais_repos')
save('result_stocke_pp_FF1Refact.mat', '-struct', 'result_stocke')
save('XY_repos_pp_FF1Refact.mat', '-struct', 'XY_repos')
