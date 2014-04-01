function struc = matchModel( obj )
% fits the generic model to the speaker-specific anatomy

nFibers = obj.nFibers;
nSamplePointsPerFiber = obj.nSamplePointsPerFiber;

nMeshPoints = nFibers * nSamplePointsPerFiber;

styloidProcess_mri = obj.landmarksTransformed.styloidProcess;

ggOriginL_mri = obj.landmarksTransformed.tongInsL;
ggOriginH_mri = obj.landmarksTransformed.tongInsH;
ANS_mri = obj.landmarksTransformed.ANS;
PNS_mri = obj.landmarksTransformed.PNS;

% Insertion points of the hyoglossus into the hyoid bone
hyoAGeneric = obj.modelGeneric.landmarks.hyoA;
hyoBGeneric = obj.modelGeneric.landmarks.hyoB;
hyoCGeneric = obj.modelGeneric.landmarks.hyoC;

larynxArytenoid = obj.anatomicalStructures.larynxArytenoid;
palateMRI       = obj.anatomicalStructures.palate;
pharynx_mri     = obj.anatomicalStructures.backPharyngealWall;
tongue_lar_mri  = obj.anatomicalStructures.tongueLarynx;
velum_mri       = obj.anatomicalStructures.velum;

% generic tongue mesh / tongue surface at rest position
tongMeshGen = obj.modelGeneric.tongGrid;
valTmp = getPositionOfNodeNumbers(tongMeshGen, 1:nMeshPoints);
X_repos = reshape(valTmp(1, :), nSamplePointsPerFiber, nFibers)';
Y_repos = reshape(valTmp(2, :), nSamplePointsPerFiber, nFibers)';
tongSurfaceGeneric = getPositionOfTongSurface(tongMeshGen);

% MRI tongue surface at rest position
tongSurfMRI = obj.anatomicalStructures.tongueSurface;

surfOut = matchTongueSurface(tongSurfaceGeneric, tongSurfMRI);

% the nodes on the adapted tongue contour correspond to the nodes of
% the tongue mesh at rest
X_repos_new(1:nFibers, nSamplePointsPerFiber) = surfOut(1, :);
Y_repos_new(1:nFibers, nSamplePointsPerFiber) = surfOut(2, :);

% lowest insertion point of the lower incisor
X_repos_new(1, 1) = ggOriginL_mri(1);
Y_repos_new(1, 1) = ggOriginL_mri(2);

[teethLowerNew, scaleFactor] = matchLowerIncisor(obj, ggOriginL_mri);

partOfMentalSpine = teethLowerNew(1:2, end:-1:end-3);
originsAdapted = matchOriginsGenioglossus(partOfMentalSpine);

X_repos_new(1:17, 1) = originsAdapted(1, :);
Y_repos_new(1:17, 1) = originsAdapted(2, :);

[X_repos_new, Y_repos_new] = matchInnerTongueMesh(X_repos, Y_repos, X_repos_new, Y_repos_new);

% match upper lip --------------------------------------
ptAttachLowerLips = teethLowerNew(1:2, 7);
lowerLip = matchLowerLip(obj, ptAttachLowerLips, scaleFactor);

% match upper incisor and upper lip --------------------------------------
[upperIncisorPalate, ptAttachLip] = matchUpperIncisor(obj, palateMRI, scaleFactor);
upperLip = matchUpperLip(obj, ptAttachLip, scaleFactor);

% calculate the 3 hyoglossus insertion points on the hyoid bone -----------
ptOriginFirstFiberGEN = [X_repos(1, 1); Y_repos(1, 1)];
ptEndFirstFiberGEN = [X_repos(1, nSamplePointsPerFiber); Y_repos(1, nSamplePointsPerFiber)];

ptOriginFirstFiberMRI = [X_repos_new(1, 1); Y_repos_new(1, 1)];
ptEndFirstFiberMRI = [X_repos_new(1, nSamplePointsPerFiber); Y_repos_new(1, nSamplePointsPerFiber)];

firstFiberMRI = [ptOriginFirstFiberMRI ptEndFirstFiberMRI];
firstFiberGEN = [ptOriginFirstFiberGEN ptEndFirstFiberGEN];

strucGen.hyoA = hyoAGeneric;
strucGen.hyoB = hyoBGeneric;
strucGen.hyoC = hyoCGeneric;

strucHyoTrans = matchHyoidBone(firstFiberGEN, firstFiberMRI, strucGen);

hyo1_new = strucHyoTrans.hyoA;
hyo2_new = strucHyoTrans.hyoB;
hyo3_new = strucHyoTrans.hyoC;


% assign values -----------------------------------------------------
lowerLipGen = obj.modelGeneric.structures.lowerLip;
lowerIncisor = obj.modelGeneric.structures.lowerIncisor;

% store data in a structure
struc.landmarks.styloidProcess = styloidProcess_mri;
struc.landmarks.condyle = [styloidProcess_mri(1); styloidProcess_mri(2)+8];
struc.landmarks.ANS(1:2, 1) = ANS_mri;
struc.landmarks.PNS(1:2, 1) = PNS_mri;
struc.landmarks.hyo1 = hyo1_new;
struc.landmarks.hyo2 = hyo2_new;
struc.landmarks.hyo3 = hyo3_new;
struc.landmarks.origin = obj.modelGeneric.landmarks.origin;
struc.landmarks.tongInsL = ggOriginL_mri;
struc.landmarks.tongInsH = ggOriginH_mri;

% store data related to the adopted vocal tract contour
% anatomical structures are not affected by adaptation
struc.structures.upperLip = upperLip;
struc.structures.upperIncisorPalate = upperIncisorPalate;
struc.structures.velum = velum_mri;
struc.structures.backPharyngealWall = pharynx_mri;
struc.structures.larynxArytenoid = larynxArytenoid;
struc.structures.tongueLarynx = tongue_lar_mri;
struc.structures.lowerIncisor = teethLowerNew;
struc.structures.lowerLip = lowerLip;

% Save the adopted tongue rest position
struc.tongGrid.x = reshape(X_repos_new', 1, nMeshPoints);
struc.tongGrid.y = reshape(Y_repos_new', 1, nMeshPoints);

end

