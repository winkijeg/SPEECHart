function model = matchModel( myModelProducer )
% fits the generic model to the speaker-specific anatomy

% variables necessary for generic and mri model
nMuscleFibers = myModelProducer.nFibers;
nSamplePointsPerFiber = myModelProducer.nSamplePointsPerFiber;
nMeshPoints = nMuscleFibers * nSamplePointsPerFiber;

% read the generic tongue mesh and restruct data for model matching
tongueMesh_generic = myModelProducer.modelGeneric.tongGrid;
vals_tmp = getPositionOfNodeNumbers(tongueMesh_generic, 1:nMeshPoints);

X_repos_generic = reshape(vals_tmp(1, :), nSamplePointsPerFiber, nMuscleFibers)';
Y_repos_generic = reshape(vals_tmp(2, :), nSamplePointsPerFiber, nMuscleFibers)';
tongSurface_generic = getPositionOfTongSurface(tongueMesh_generic);

clear tongueMesh_generic valTmp;

% derive tongue insertion points in the generic model
tongInsL_generic = [X_repos_generic(1, 1); Y_repos_generic(1, 1)];
tongInsH_generic = [X_repos_generic(nMuscleFibers, 1); Y_repos_generic(nMuscleFibers, 1)];

tongInsL_mri = myModelProducer.landmarksTransformed.tongInsL;
tongInsH_mri = myModelProducer.landmarksTransformed.tongInsH;

% calculate scale factor used for matching of -----------------------------
% - lower lip and lower incisor
% - upper lip and upper incisor
scaleFactor = calculateMatchingScaleFactor(tongInsH_mri, ...
    tongInsL_mri, tongInsH_generic, tongInsL_generic);


% step 1: match mri tongue surface ----------------------------------------
tongSurface_mri = myModelProducer.anatomicalStructures.tongueSurface;
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
lowerLip = matchLowerLip(myModelProducer, ptAttachLowerLips, scaleFactor);

% match upper incisor and upper lip --------------------------------------
palateMRI = myModelProducer.anatomicalStructures.palate;

[upperIncisorPalate, ptAttachLip] = matchUpperIncisor(myModelProducer, palateMRI, scaleFactor);
upperLip = matchUpperLip(myModelProducer, ptAttachLip, scaleFactor);

% calculate the 3 hyoglossus insertion points on the hyoid bone -----------
ptOriginFirstFiberGEN = [X_repos_generic(1, 1); Y_repos_generic(1, 1)];
ptEndFirstFiberGEN = [X_repos_generic(1, nSamplePointsPerFiber); Y_repos_generic(1, nSamplePointsPerFiber)];

ptOriginFirstFiberMRI = [X_repos_matched(1, 1); Y_repos_matched(1, 1)];
ptEndFirstFiberMRI = [X_repos_matched(1, nSamplePointsPerFiber); Y_repos_matched(1, nSamplePointsPerFiber)];

firstFiberMRI = [ptOriginFirstFiberMRI ptEndFirstFiberMRI];
firstFiberGEN = [ptOriginFirstFiberGEN ptEndFirstFiberGEN];

% Insertion points of the hyoglossus into the hyoid bone
strucGen.hyoA = myModelProducer.modelGeneric.landmarks.hyoA;
strucGen.hyoB = myModelProducer.modelGeneric.landmarks.hyoB;
strucGen.hyoC = myModelProducer.modelGeneric.landmarks.hyoC;

strucHyoTrans = matchHyoidBone(firstFiberGEN, firstFiberMRI, strucGen);

hyo1_new = strucHyoTrans.hyoA;
hyo2_new = strucHyoTrans.hyoB;
hyo3_new = strucHyoTrans.hyoC;


% assign values -----------------------------------------------------
lowerLipGen = myModelProducer.modelGeneric.structures.lowerLip;
lowerIncisor = myModelProducer.modelGeneric.structures.lowerIncisor;

% store data in a structure
model.landmarks.styloidProcess = myModelProducer.landmarksTransformed.styloidProcess;
model.landmarks.condyle = myModelProducer.landmarksTransformed.styloidProcess + [0; 8];
model.landmarks.ANS = myModelProducer.landmarksTransformed.ANS;
model.landmarks.PNS = myModelProducer.landmarksTransformed.PNS;

model.landmarks.hyo1 = hyo1_new;
model.landmarks.hyo2 = hyo2_new;
model.landmarks.hyo3 = hyo3_new;
model.landmarks.origin = myModelProducer.modelGeneric.landmarks.origin;
model.landmarks.tongInsL = tongInsL_mri;
model.landmarks.tongInsH = myModelProducer.landmarksTransformed.tongInsH;

% store data related to the adopted vocal tract contour
% anatomical structures are not affected by adaptation
model.structures.upperLip = upperLip;
model.structures.upperIncisorPalate = upperIncisorPalate;
model.structures.velum = myModelProducer.anatomicalStructures.velum;
model.structures.backPharyngealWall = myModelProducer.anatomicalStructures.backPharyngealWall;
model.structures.larynxArytenoid = myModelProducer.anatomicalStructures.larynxArytenoid;
model.structures.tongueLarynx = myModelProducer.anatomicalStructures.tongueLarynx;
model.structures.lowerIncisor = teethLowerNew;
model.structures.lowerLip = lowerLip;

% Save the adopted tongue rest position
model.tongGrid.x = reshape(X_repos_matched', 1, nMeshPoints);
model.tongGrid.y = reshape(Y_repos_matched', 1, nMeshPoints);

end

