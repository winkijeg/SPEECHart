% test creating an object of class SpeakerModel from three obsolete mat-files

clearvars

spkName = 'cs';

nNodes = 221;

fn_structuresRepos_obs = ['data_palais_repos_' spkName '.mat'];
fn_tongueRepos_obs = ['XY_repos_' spkName '.mat'];
fn_result_stoke_obs = ['result_stocke_' spkName '.mat'];

path_data_obs = ['code_sprechart_obs/' spkName '/'];

path_mat_model = ['e:/projects/project_refactoring/data/' spkName '/model/'];
fn_mat_model = [spkName '_model.mat'];


% collect data from data_palais_repos_xx.mat
structRepos = load([path_data_obs fn_structuresRepos_obs]);

mat.landmarks.styloidProcess = [structRepos.XS; structRepos.YS];

mat.landmarks.hyo1 = [structRepos.X1; structRepos.Y1];
mat.landmarks.hyo2 = [structRepos.X2; structRepos.Y2];
mat.landmarks.hyo3 = [structRepos.X3; structRepos.Y3];
mat.landmarks.condyle = [structRepos.XS; structRepos.YS+8];

mat.structures.upperLip = structRepos.upperlip;
mat.structures.upperIncisorPalate = structRepos.palate; % split contour ???
mat.structures.velum = structRepos.velum;
mat.structures.backPharyngealWall = structRepos.pharynx;
mat.structures.larynxArytenoid = structRepos.lar_ar; % ****** ?
mat.structures.tongueLarynx = structRepos.tongue_lar;  % ****** ?
mat.structures.lowerIncisor = structRepos.dents_inf;
mat.structures.lowerLip = structRepos.lowlip;

% collect data from XY_repos_xx.mat

tongueRepos = load([path_data_obs fn_tongueRepos_obs]);
% calculate origin ... Average position of the tongue contour in the sagittal
% plane. This will be use to position the other contours around the same
% average position whatever the position of the subject's head in the mri
% scanner.
[maxRowRaw, maxColRaw] = size(tongueRepos.X_repos);
origin(1, 1) = mean(tongueRepos.X_repos(:, maxColRaw)); % x coordinates
origin(2, 1) = mean(tongueRepos.Y_repos(:, maxColRaw)); % y coordinates
mat.landmarks.origin = origin;

% determine position of the final 221 nodes by interpolation (fact = 2)
fact = 2;

% Number of "horizontal" (MM=17 for 221 nodes) and "vertical" (NN=13 for 221 nodes) lines
for j=1:maxRowRaw
    X0(fact*(j-1)+1, 1:fact*(maxColRaw-1)+1) = ...
        interp1(1:maxColRaw, tongueRepos.X_repos(j,1:maxColRaw), 1:1/fact:maxColRaw, 'spline');
end
for j=1:maxColRaw
    Y0(1:fact*(maxRowRaw-1)+1, fact*(j-1)+1) = ...
        interp1(1:maxRowRaw,tongueRepos.Y_repos(1:maxRowRaw,j), 1:1/fact:maxRowRaw, 'spline')';
end
for j=1:fact*(maxColRaw-1)+1
    X0(:,j) = interp1(find(X0(:,j)), nonzeros(X0(:,j)), 1:fact*(maxRowRaw-1)+1, 'spline')';
end
for j=1:fact*(maxRowRaw-1)+1
    Y0(j,:) = interp1(find(Y0(j,:)), nonzeros(Y0(j,:)), 1:fact*(maxColRaw-1)+1, 'spline');
end

% convert from matrix Form to (formerly) XY-form
mat.tongGrid.x = reshape(X0', 1, nNodes);
mat.tongGrid.y = reshape(Y0', 1, nNodes);

% - save mat-file of generic model -------------------------------------------

save ([path_mat_model fn_mat_model], '-struct', 'mat')

% ----------------------------------------------------------------------------
% --- test mat-file  ---------------------------------------------------------

myModel = SpeakerModel(mat);

% save in obsolete format (3 mat-files)  ------------------------------------
matsObsolete = exportModelObsolete(myModel);

mat_data_palais_repos = matsObsolete.data_palais_repos;
save ([path_mat_model fn_structuresRepos_obs], '-struct', 'mat_data_palais_repos');

mat_XY_repos = matsObsolete.XY_repos;
save ([path_mat_model fn_tongueRepos_obs], '-struct', 'mat_XY_repos');

mat_result_stocke = matsObsolete.result_stocke;
save ([path_mat_model fn_result_stoke_obs], '-struct', 'mat_result_stocke');

% just to verify that everything went well ...................
initPlotFigure(myModel, false);

plotStructures(myModel, 'k');
plotLandmarks(myModel, 'c');
plotTongueMesh(myModel, [0.5 0.5 0.5]);
drawNodeNumbers(myModel.tongGrid)
drawTongSurface(myModel.tongGrid, 'r');
