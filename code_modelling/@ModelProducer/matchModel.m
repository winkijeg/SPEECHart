function struc = matchModel( obj )
% fits the generic model to the speaker-specific anatomy

nFibers = 17;
nSamplePointsPerFiber = 13;

styloidProcess_mri = obj.landmarksTransformed.styloidProcess;

ggOriginL_mri = obj.landmarksTransformed.tongInsL;
ggOriginH_mri = obj.landmarksTransformed.tongInsH;
ANS_mri = obj.landmarksTransformed.ANS;
PNS_mri = obj.landmarksTransformed.PNS;

% Insertion points of the hyoglossus into the hyoid bone
hyoAGeneric = obj.modelGeneric.landmarks.hyoA;
hyoBGeneric = obj.modelGeneric.landmarks.hyoB;
hyoCGeneric = obj.modelGeneric.landmarks.hyoC;
tongInsLGeneric = obj.modelGeneric.landmarks.tongInsL;
tongInsHGeneric = obj.modelGeneric.landmarks.tongInsH;


larynxArytenoid = obj.anatomicalStructures.larynxArytenoid;
palateMRI = obj.anatomicalStructures.palate;
pharynx_mri = obj.anatomicalStructures.backPharyngealWall;
tongue_lar_mri = obj.anatomicalStructures.tongueLarynx;
velum_mri = obj.anatomicalStructures.velum;

% generic tongue mesh / tongue surface at rest position
tongMeshGen = obj.modelGeneric.tongGrid;
valTmp = getPositionOfNodeNumbers(tongMeshGen, 1:221);
X_repos = reshape(valTmp(1, :), nSamplePointsPerFiber, nFibers)';
Y_repos = reshape(valTmp(2, :), nSamplePointsPerFiber, nFibers)';
tongSurfaceGeneric = getPositionOfTongSurface(tongMeshGen);


% MRI tongue surface at rest position
tongSurfMRI = obj.anatomicalStructures.tongueSurface;

surfOut = matchTongueSurface(tongSurfaceGeneric, tongSurfMRI);

% the nodes on the adapted tongue contour correspond to the nodes of
% the tongue mesh at rest (ncol = 13)
X_repos_new(1:17, nSamplePointsPerFiber) = surfOut(1, :);
Y_repos_new(1:17, nSamplePointsPerFiber) = surfOut(2, :);

% lowest insertion point of the lower incisor
X_repos_new(1, 1) = ggOriginL_mri(1);
Y_repos_new(1, 1) = ggOriginL_mri(2);

% Upper insertion on the incisor
X_repos_new(nFibers, 1) = ggOriginH_mri(1);
Y_repos_new(nFibers, 1) = ggOriginH_mri(2);



[teethLowerNew, scaleFactor] = matchLowerIncisor(obj, ggOriginL_mri);

% first (lowest) 3 mesh lines
% devide space between teeth last two teeth points into two sections

lineSegTmp = teethLowerNew(1:2, end:-1:end-1);
ptsTmp = polyline_points_nd(2, 2, lineSegTmp, 3);

X_repos_new(2, 1) = ptsTmp(1, 2);
Y_repos_new(2, 1) = ptsTmp(2, 2);

X_repos_new(3, 1) = ptsTmp(1, 3);
Y_repos_new(3, 1) = ptsTmp(2, 3);


% second section (2/3)
lineSegTmp = teethLowerNew(1:2, end-1:-1:end-2);
ptsTmp = polyline_points_nd(2, 2, lineSegTmp, 7);

X_repos_new(4, 1) = ptsTmp(1, 2);
Y_repos_new(4, 1) = ptsTmp(2, 2);

X_repos_new(5, 1) = ptsTmp(1, 3);
Y_repos_new(5, 1) = ptsTmp(2, 3);

X_repos_new(6, 1) = ptsTmp(1, 4);
Y_repos_new(6, 1) = ptsTmp(2, 4);

X_repos_new(7, 1) = ptsTmp(1, 5);
Y_repos_new(7, 1) = ptsTmp(2, 5);

X_repos_new(8, 1) = ptsTmp(1, 6);
Y_repos_new(8, 1) = ptsTmp(2, 6);

X_repos_new(9, 1) = ptsTmp(1, 7);
Y_repos_new(9, 1) = ptsTmp(2, 7);

% third section (3/3)
lineSegTmp = teethLowerNew(1:2, end-2:-1:end-3);
ptsTmp = polyline_points_nd(2, 2, lineSegTmp, 9);

X_repos_new(10, 1) = ptsTmp(1, 2);
Y_repos_new(10, 1) = ptsTmp(2, 2);

X_repos_new(11, 1) = ptsTmp(1, 3);
Y_repos_new(11, 1) = ptsTmp(2, 3);

X_repos_new(12, 1) = ptsTmp(1, 4);
Y_repos_new(12, 1) = ptsTmp(2, 4);

X_repos_new(13, 1) = ptsTmp(1, 5);
Y_repos_new(13, 1) = ptsTmp(2, 5);

X_repos_new(14, 1) = ptsTmp(1, 6);
Y_repos_new(14, 1) = ptsTmp(2, 6);

X_repos_new(15, 1) = ptsTmp(1, 7);
Y_repos_new(15, 1) = ptsTmp(2, 7);

X_repos_new(16, 1) = ptsTmp(1, 8);
Y_repos_new(16, 1) = ptsTmp(2, 8);

% 17th point is assigned elsewhere ...




% Computation of the internal nodes of the adapted tongue model
for i = 1:nFibers
    % distance between the node on the mri tongue surface and the 
    % corresponding insertion nodes on the incisor
    p1 = [X_repos_new(i, nSamplePointsPerFiber); Y_repos_new(i, nSamplePointsPerFiber)];
    p2 = [X_repos_new(i, 1); Y_repos_new(i, 1)];
    lengthFirstFiberGGMRI = points_dist_nd(2, p1', p2');
    % the same for the generic model
    p1 = [X_repos(i, nSamplePointsPerFiber); Y_repos(i, nSamplePointsPerFiber)];
    p2 = [X_repos(i, 1); Y_repos(i, 1)];
    lengthFirstFiberGGGeneric = points_dist_nd(2, p1', p2');
    
    lengthRatioCurrentRow = lengthFirstFiberGGMRI / lengthFirstFiberGGGeneric;
    
    % Sign of the vertical difference between the node on the upper contour
    % of the adapted model and the corresponding insertion nodes on the incisor
    signe_new = sign((Y_repos_new(i, nSamplePointsPerFiber) - Y_repos_new(i, 1)));
    % Sign of the vertical difference between the node on the upper contour of
    % YPM and the corresponding insertion nodes on the incisor
    signe_mod = sign((Y_repos(i, nSamplePointsPerFiber)-Y_repos(i, 1)));
    % Angle of the line joining the node on the mri tongue surface
    % and the corresponding insertion nodes on the incisor
    angleMRI = signe_new * ...
        acos((X_repos_new(i, nSamplePointsPerFiber) - X_repos_new(i, 1)) / lengthFirstFiberGGMRI);
    % Angle of the line joining the node on the upper contour of YPM and the
    % corresponding insertion nodes on the incisor
    angleGeneric = signe_mod * ...
        acos((X_repos(i, nSamplePointsPerFiber) - X_repos(i, 1)) / lengthFirstFiberGGGeneric);
    % The difference between these two angles is a measure of the global
    % rotation of the current line
    angle_rotat = angleMRI - angleGeneric;
    
    
    distTmp = nan(1, nSamplePointsPerFiber-1);
    signTmp = nan(1, nSamplePointsPerFiber-1);
    angle_intern = nan(1, nSamplePointsPerFiber-1);
    angle_final = nan(1, nSamplePointsPerFiber-1);
    for j = 2:nSamplePointsPerFiber-1
        % Now we consider each internal node of the current line separately
        % Distance between this node and the corresponding insertion node
        % on the incisor in the original tongue model (YPM)
        distTmp(j) = sqrt((X_repos(i,j)-X_repos(i,1))^2+(Y_repos(i,j)-Y_repos(i,1))^2);
        % Sign of the vertical difference between this node and the
        % corresponding insertion node on the incisor in the generic model (YPM)
        signTmp(j) = sign((Y_repos(i,j)-Y_repos(i,1)));
        % Angle of the line joining this node and the corresponding insertion
        % node on the incisor in YPM
        angle_intern(j) = signTmp(j)*abs(acos((X_repos(i,j)-X_repos(i,1))/distTmp(j)));
        % Angle of the line joining this node and the corresponding insertion
        % node on the incisor in the adapted model after a rotation equal to
        % the global rotation of the current line
        angle_final(j) = angle_intern(j) + angle_rotat;
        
        % Position of the corresponding node in the adapted model
        X_repos_new(i, j) = X_repos_new(i, 1) + lengthRatioCurrentRow*distTmp(j)*cos(angle_final(j));
        Y_repos_new(i, j) = Y_repos_new(i, 1) + lengthRatioCurrentRow*distTmp(j)*sin(angle_final(j));
        
% % %         plot(X_repos(i, j), Y_repos(i, j), 'ob')
% % %         % Plot the nodes on the corresponding line in the adapted model
% % %         plot(X_repos_new(i,j), Y_repos_new(i,j), '+r', 'Linewidth', 2)
        
    end
    
end


% end mesh adaptation ----------------------------------------------------

% % % % Plot the new mesh
% % % for j=1:nColTongueMesh
% % %     for i=1:nRowTongMesh-1
% % %         plot([X_repos_new(i,j) X_repos_new(i+1,j)], ...
% % %             [Y_repos_new(i,j) Y_repos_new(i+1,j)], 'r')
% % %     end
% % % end
% % % for i=1:nRowTongMesh
% % %     for j=1:nColTongueMesh-1
% % %         plot([X_repos_new(i,j) X_repos_new(i,j+1)], ...
% % %             [Y_repos_new(i,j) Y_repos_new(i,j+1)], 'r')
% % %     end
% % % end
figure
plot(teethLowerNew(1,:), teethLowerNew(2,:),'go-')
hold on
axis equal

% match upper lip --------------------------------------
ptAttachLowerLips = teethLowerNew(1:2, 7);
lowerLip = matchLowerLip(obj, ptAttachLowerLips, scaleFactor);

plot(lowerLip(1,:), lowerLip(2,:),'g')


% match upper incisor and upper lip --------------------------------------
[upperIncisorPalate, ptAttachLip] = matchUpperIncisor(obj, palateMRI, scaleFactor);
upperLip = matchUpperLip(obj, ptAttachLip, scaleFactor);






% calculate the 3 hyoglossus insertion points on the hyoid bone -----------

% in order to predict the hyoid bone position in the adapted
% model we take into account the rapport_dist and angle_rotat
% parameters found for the two 1st genioglossus fibers
p1 = [X_repos_new(1, nSamplePointsPerFiber); Y_repos_new(1, nSamplePointsPerFiber)];
p2 = [X_repos_new(1, 1); Y_repos_new(1, 1)];
lengthFirstFiberGGMRI = points_dist_nd(2, p1', p2');
% the same for the generic model
p1 = [X_repos(1, nSamplePointsPerFiber); Y_repos(1, nSamplePointsPerFiber)];
p2 = [tongInsLGeneric(1); Y_repos(1, 1)];
lengthFirstFiberGGGeneric = points_dist_nd(2, p1', p2');
distRatioFirstFibers = lengthFirstFiberGGMRI / lengthFirstFiberGGGeneric;

% sign of the vertical difference between the node on the upper contour
% of the adapted model and the corresponding insertion nodes on the incisor
signe_new = sign((Y_repos_new(1, nSamplePointsPerFiber)-Y_repos_new(1,1)));
% Sign of the vertical difference between the node on the upper contour of
% YPM and the corresponding insertion nodes on the incisor
signe_mod = sign((Y_repos(1, nSamplePointsPerFiber)-Y_repos(1,1)));
% Angle of the line joining the node on the upper contour of adapted model
% and the corresponding insertion nodes on the incisor
angleMRI = signe_new * ...
    acos((X_repos_new(1, nSamplePointsPerFiber) - X_repos_new(1,1)) / lengthFirstFiberGGMRI);
% Angle of the line joining the node on the upper contour of YPM and the
% corresponding insertion nodes on the incisor
angleGeneric = signe_mod * ...
    acos((X_repos(1, nSamplePointsPerFiber) - tongInsLGeneric(1)) / lengthFirstFiberGGGeneric);
% The difference between these two angles is a measure of the global
% rotation of the first line (mouth floor)

% The line joining the lowest insertion point of the tongue
% on the incisor and the lowest point of hyoid bone (hyoA) will be
% rotated in the adapted model by the same angle as the lowest
% line of the mesh
angle_rotat_hyoid = angleMRI - angleGeneric;
distHyoTongInsGen = points_dist_nd(2, hyoAGeneric, tongInsLGeneric);

% Angle of the line joining the first point of the hyoid bone (hyoA) and the
% lowest insertion point of the tongue (tongInsL) in the generic model
angle_hyoid1 = -1 * abs(acos((hyoAGeneric(1) - tongInsLGeneric(1)) / distHyoTongInsGen));
radians_to_degrees(angle_hyoid1);


% Angle of the line joining the first hyoid point (hyoA) and the lowest 
% insertion point of the tongue on the incisor (tongInsL) in the mri after 
% a rotation with an angle angle_rotat_hyoid equal to the rotation
% of the lowest line of the mesh (see above)
angle_final_hyoid1 = angle_hyoid1 + angle_rotat_hyoid;

% Position of the corresponding point in the adapted model
hyo1_new(1, 1) = ggOriginL_mri(1) + ...
    (distRatioFirstFibers * distHyoTongInsGen * cos(angle_final_hyoid1));
hyo1_new(2, 1) = ggOriginL_mri(2) + ...
    (distRatioFirstFibers * distHyoTongInsGen * sin(angle_final_hyoid1));

% the remaining insertion points will be defined from the points of the
% hyoid bone in the generic model
hyo2_new = hyo1_new + hyoBGeneric - hyoAGeneric;
hyo3_new = hyo1_new + hyoCGeneric - hyoAGeneric;


% new version

% strucGen.tongInsL = tongInsLGeneric;
% strucGen.hyoA = hyoAGeneric;
% strucGen.hyoB = hyoBGeneric;
% strucGen.hyoC = hyoCGeneric;
% 
% strucHyoTrans = transform_hyoidBone(tongInsL_mri, strucGen);
% 
% hyo1_new = strucHyoTrans.hyoA
% hyo2_new = strucHyoTrans.hyoB
% hyo3_new = strucHyoTrans.hyoC
% 
% end 3 hyoglossus points -------------------------------------------------




lowerLipGen = obj.modelGeneric.structures.lowerLip;
lowerIncisor = obj.modelGeneric.structures.lowerIncisor;
plot(lowerIncisor(1, :), lowerIncisor(2, :), 'ro-')
plot(lowerLipGen(1, :), lowerLipGen(2, :), 'ro-')


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
struc.tongGrid.x = reshape(X_repos_new', 1, 221);
struc.tongGrid.y = reshape(Y_repos_new', 1, 221);

end

