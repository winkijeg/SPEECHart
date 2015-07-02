function matModel = matchModel( obj )
% fits the generic model to the speaker-specific anatomy

% variables necessary for generic and mri model
nMuscleFibers = obj.nFibers;
nSamplePointsPerFiber = obj.nSamplePointsPerFiber;
nMeshPoints = nMuscleFibers * nSamplePointsPerFiber;

% read the generic tongue mesh and restruct data for model matching
tongueMesh_generic = obj.modelGeneric.tongGrid;
vals_tmp = getPositionOfNodeNumbers(tongueMesh_generic, 1:nMeshPoints);

X_repos_generic = reshape(vals_tmp(1, :), nSamplePointsPerFiber, nMuscleFibers)';
Y_repos_generic = reshape(vals_tmp(2, :), nSamplePointsPerFiber, nMuscleFibers)';
tongSurface_generic = getPositionOfTongSurface(tongueMesh_generic);

clear tongueMesh_generic valTmp;

% derive tongue insertion points in the generic model
tongInsL_generic = [X_repos_generic(1, 1); Y_repos_generic(1, 1)];
tongInsH_generic = [X_repos_generic(nMuscleFibers, 1); Y_repos_generic(nMuscleFibers, 1)];

tongInsL_mri = obj.landmarksTransformed.tongInsL;
tongInsH_mri = obj.landmarksTransformed.tongInsH;

% calculate scale factor used for matching of -----------------------------
% - lower lip and lower incisor
% - upper lip and upper incisor
scaleFactor = calculateMatchingScaleFactor(tongInsH_mri, ...
    tongInsL_mri, tongInsH_generic, tongInsL_generic);


% step 1: match mri tongue surface ----------------------------------------
tongSurface_mri = obj.anatomicalStructures.tongueSurface;
tongSurface_matched = matchTongueSurface(tongSurface_generic, tongSurface_mri);

clear tongSurface_mri;

% step 2: match mri lower incissor ----------------------------------------
teethLowerNew = matchLowerIncisor(tongInsL_mri, tongInsH_mri, scaleFactor);


X_repos_matched(1:nMuscleFibers, nSamplePointsPerFiber) = tongSurface_matched(1, :);
Y_repos_matched(1:nMuscleFibers, nSamplePointsPerFiber) = tongSurface_matched(2, :);

X_repos_matched(1, 1) = tongInsL_mri(1);
Y_repos_matched(1, 1) = tongInsL_mri(2);

originsAdapted = matchOriginsGenioglossus(teethLowerNew(1:2, end:-1:end-3));

X_repos_matched(1:17, 1) = originsAdapted(1, :);
Y_repos_matched(1:17, 1) = originsAdapted(2, :);

[X_repos_matched, Y_repos_matched] = matchInnerTongueMesh(X_repos_generic, Y_repos_generic, X_repos_matched, Y_repos_matched);

% match upper lip --------------------------------------
ptAttachLowerLips = teethLowerNew(1:2, 7);
lowerLip = ModelProducer.matchLowerLip(ptAttachLowerLips, scaleFactor);

% match upper incisor and upper lip --------------------------------------
palateMRI = obj.anatomicalStructures.palate;

[upperIncisorPalate, ptAttachLip] = matchUpperIncisor(obj, palateMRI, scaleFactor);
upperLip = matchUpperLip(obj, ptAttachLip, scaleFactor);

% calculate the 3 hyoglossus insertion points on the hyoid bone -----------
ptOriginFirstFiberGEN = [X_repos_generic(1, 1); Y_repos_generic(1, 1)];
ptEndFirstFiberGEN = [X_repos_generic(1, nSamplePointsPerFiber); Y_repos_generic(1, nSamplePointsPerFiber)];

ptOriginFirstFiberMRI = [X_repos_matched(1, 1); Y_repos_matched(1, 1)];
ptEndFirstFiberMRI = [X_repos_matched(1, nSamplePointsPerFiber); Y_repos_matched(1, nSamplePointsPerFiber)];

firstFiberMRI = [ptOriginFirstFiberMRI ptEndFirstFiberMRI];
firstFiberGEN = [ptOriginFirstFiberGEN ptEndFirstFiberGEN];

% Insertion points of the hyoglossus into the hyoid bone
strucGen.hyoA = obj.modelGeneric.landmarks.xyHyoA;
strucGen.hyoB = obj.modelGeneric.landmarks.xyHyoB;
strucGen.hyoC = obj.modelGeneric.landmarks.xyHyoC;

strucHyoTrans = matchHyoidBone(firstFiberGEN, firstFiberMRI, strucGen);

hyo1_new = strucHyoTrans.hyoA;
hyo2_new = strucHyoTrans.hyoB;
hyo3_new = strucHyoTrans.hyoC;


% assign values -----------------------------------------------------
lowerLipGen = obj.modelGeneric.structures.lowerLip;
lowerIncisor = obj.modelGeneric.structures.lowerIncisor;

% store data in a structure
matModel.modelName = obj.modelName;
matModel.modelUUID = char(java.util.UUID.randomUUID);

matModel.landmarks.xyStyloidProcess = obj.landmarksTransformed.styloidProcess;
matModel.landmarks.xyCondyle = obj.landmarksTransformed.condyle;
matModel.landmarks.xyANS = obj.landmarksTransformed.ANS;
matModel.landmarks.xyPNS = obj.landmarksTransformed.PNS;

matModel.landmarks.xyHyoA = hyo1_new;
matModel.landmarks.xyHyoB = hyo2_new;
matModel.landmarks.xyHyoC = hyo3_new;
matModel.landmarks.xyOrigin = obj.modelGeneric.landmarks.xyOrigin;
matModel.landmarks.xyTongInsL = tongInsL_mri;
matModel.landmarks.xyTongInsH = obj.landmarksTransformed.tongInsH;

% store data related to the adopted vocal tract contour
% anatomical structures are not affected by adaptation
matModel.structures.upperLip = upperLip;
matModel.structures.upperIncisorPalate = upperIncisorPalate;
matModel.structures.velum = obj.anatomicalStructures.velum;
matModel.structures.backPharyngealWall = obj.anatomicalStructures.backPharyngealWall;
matModel.structures.larynxArytenoid = obj.anatomicalStructures.larynxArytenoid;
matModel.structures.tongueLarynx = obj.anatomicalStructures.tongueLarynx;
matModel.structures.lowerIncisor = teethLowerNew;
matModel.structures.lowerLip = lowerLip;

% Save the adopted tongue rest position
matModel.tongGrid.xVal = reshape(X_repos_matched', 1, nMeshPoints);
matModel.tongGrid.yVal = reshape(Y_repos_matched', 1, nMeshPoints);

end

