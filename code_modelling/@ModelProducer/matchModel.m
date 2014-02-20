function struc = matchModel( obj )
% fits the generic model to the speaker-specific anatomy

nRowTongMesh = 17;
nColTongueMesh = 13;

tongSurf_mri = obj.anatomicalStructures.tongueSurface;
nPointsTongSurf_mri = size(tongSurf_mri, 2);

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

% generic tongue mesh at rest position
tongMeshGen = obj.modelGeneric.tongGrid; % Class PositionFrame
valTmp = getPositionOfNodeNumbers(tongMeshGen, 1:221);
X_repos = reshape(valTmp(1, :), nColTongueMesh, nRowTongMesh)';
Y_repos = reshape(valTmp(2, :), nColTongueMesh, nRowTongMesh)';

% tongue surface of generic model
xValsTongSurfGenMatrix = X_repos(:, nColTongueMesh); % x coordinates
yValsTongSurfGenMatrix = Y_repos(:, nColTongueMesh); % y coordinates
tongSurfGen = [xValsTongSurfGenMatrix'; yValsTongSurfGenMatrix'];
nPointsTongSurfGen = length(xValsTongSurfGenMatrix);

% Interpolation of the tongue contour of the target speaker in order to
% get a better matching of this contour starting from YPM's contour. We take
% 10 times more nodes for a better definition of the speaker-specific
% tongue contour
xValsTongSurgMRIOrig = ...
    spline(1:nPointsTongSurf_mri, tongSurf_mri(1, :), 1:1/10:nPointsTongSurf_mri);
yValsTongSurgMRIOrig = ...
    spline(1:nPointsTongSurf_mri, tongSurf_mri(2, :), 1:1/10:nPointsTongSurf_mri);

tongSurf_mri = [xValsTongSurgMRIOrig; yValsTongSurgMRIOrig];
nPointsTongSurfMRIOrig = length(xValsTongSurgMRIOrig);

% Plot the data around the generic average position ----------------------
% % % figure
% % % % Plot the generic tongue
% % % for j = 1:nColTongueMesh
% % %     for i = 1:nRowTongMesh-1
% % %         plot([X_repos(i,j) X_repos(i+1,j)], ...
% % %             [Y_repos(i,j) Y_repos(i+1,j)], ':r')
% % %         hold on
% % %     end
% % % end
% % % for i = 1:nRowTongMesh
% % %     for j = 1:nColTongueMesh-1
% % %         plot([X_repos(i,j) X_repos(i,j+1)], ...
% % %             [Y_repos(i,j) Y_repos(i,j+1)], ':r')
% % %     end
% % % end
% % % 
% % % % draw in green the nodes of the generic tongue surface
% % % plot(xValsTongSurfGenMatrix, yValsTongSurfGenMatrix,'*g')
% % % hold on
% % % 
% % % % plot the interpolated MRI tongue surface
% % % plot(tongSurf_mri(1, :), tongSurf_mri(2, :), 'b*', 'Linewidth', 2)
% % % axis('equal')

% end plotting ------------------------------------------------------------


% computation of the piecewise length of the generic tongue contour
lenSegTongSurfGen = nan(1, nPointsTongSurfGen-1);
for k = 1:nPointsTongSurfGen-1
    lenSegTongSurfGen(k) = points_dist_nd (2, ...
        tongSurfGen(:, k), tongSurfGen(:, k+1));
end
lenTotTongSurfGen = sum(lenSegTongSurfGen);

% computation of the piecewise length of the mri tongue contour
lenSegTongSurfMRIOrig = nan(1, nPointsTongSurfMRIOrig-1);
for k = 1:nPointsTongSurfMRIOrig-1
    lenSegTongSurfMRIOrig(k) = points_dist_nd (2, ...
        tongSurf_mri(:, k), tongSurf_mri(:, k+1));
end
lenTotTongSurfMRI = sum(lenSegTongSurfMRIOrig);

% calculate the relative position of the nodes along the generic tongue surface. 
% the reference point is the first point of the
% surface located on the hyoid bone. The relative position of each surface node 
% is characterised by the ratio ratioRelPosGen of its distance to the 
% reference point divided by the total length of the tongue surface.

% for the first point the ratio is obviously 0
ratiosRelPosGen = nan(1, nPointsTongSurfGen);
ratiosRelPosGen(1) = 0;
for k = 2:nPointsTongSurfGen
    ratiosRelPosGen(k) = sum(lenSegTongSurfGen(1:k-1)) / lenTotTongSurfGen;
end

ratiosRelPosMRI = nan(1, nPointsTongSurfMRIOrig);
ratiosRelPosMRI(1) = 0;
for i = 2:nPointsTongSurfMRIOrig
    % Ratio for the other points on the contour
    ratiosRelPosMRI(i) = sum(lenSegTongSurfMRIOrig(1:i-1)) / lenTotTongSurfMRI;
end

% constructing the adapted tongue surface
% the matching process starts by aligning the first point of the adapted
% model (on the hyoid bone) with the first point of the tongue contour of
% the target speaker, and by aligning the tongue tip point of the adapted
% model with the last point of the tongue contour of the target speaker.

% lowest point of the adapted tongue surface = lowest point
% of the speaker specific tongue contour
x_new(1) = xValsTongSurgMRIOrig(1);
% Lowest point of the upper contour of the adapted model = Lowest point
% of the speaker specific tongue contour
y_new(1) = yValsTongSurgMRIOrig(1);
% Tongue tip point of the upper contour of the adapted model = Tongue tip
% point of the speaker specific tongue contour
x_new(nPointsTongSurfGen) = xValsTongSurgMRIOrig(nPointsTongSurfMRIOrig);
% Tongue tip point of the upper contour of the adapted model = Tongue tip
% point of the speaker specific tongue contour
y_new(nPointsTongSurfGen) = yValsTongSurgMRIOrig(nPointsTongSurfMRIOrig);




% To match the upper contour of the adapted model with the tongue contour of
% the target subject each node n of the generic tongue surface is projected onto
% the point nREF of the tongue contour of the target speaker, for which the
% ratio prop_elem_ref gives the best approximation of the ratio
% prop_elem_mod calculated for generic node n.
jlast = 1;
for k = 2:nPointsTongSurfGen-1
    j = jlast;
    while (j < nPointsTongSurfMRIOrig)
        j = j + 1;
        if ratiosRelPosMRI(j-1) < ratiosRelPosGen(k) && ratiosRelPosMRI(j) >= ratiosRelPosGen(k)
            jlast = j;
            x_new(k) = xValsTongSurgMRIOrig(j);
            y_new(k) = yValsTongSurgMRIOrig(j);
            j = nPointsTongSurfMRIOrig;
        end
    end
end



% plot adapted tongue surface and shows displacement from generic
% % % plot(x_new, y_new, 'or', 'Linewidth', 2)
% % % for i = 1:nPointsTongSurfGen
% % %     plot([xValsTongSurfGenMatrix(i) x_new(i)], [yValsTongSurfGenMatrix(i) y_new(i)], ':g')
% % % end
% % % 



% the nodes on the adapted tongue contour correspond to the nodes of
% the tongue mesh at rest (ncol = 13)
X_repos_new(1:17, nColTongueMesh) = x_new;
Y_repos_new(1:17, nColTongueMesh) = y_new;

% lowest insertion point of the lower incisor
X_repos_new(1, 1) = ggOriginL_mri(1);
Y_repos_new(1, 1) = ggOriginL_mri(2);

% Upper insertion on the incisor
X_repos_new(nRowTongMesh, 1) = ggOriginH_mri(1);
Y_repos_new(nRowTongMesh, 1) = ggOriginH_mri(2);



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
for i = 1:nRowTongMesh
    % distance between the node on the mri tongue surface and the 
    % corresponding insertion nodes on the incisor
    p1 = [X_repos_new(i, nColTongueMesh); Y_repos_new(i, nColTongueMesh)];
    p2 = [X_repos_new(i, 1); Y_repos_new(i, 1)];
    lengthFirstFiberGGMRI = points_dist_nd(2, p1', p2');
    % the same for the generic model
    p1 = [X_repos(i, nColTongueMesh); Y_repos(i, nColTongueMesh)];
    p2 = [X_repos(i, 1); Y_repos(i, 1)];
    lengthFirstFiberGGGeneric = points_dist_nd(2, p1', p2');
    
    lengthRatioCurrentRow = lengthFirstFiberGGMRI / lengthFirstFiberGGGeneric;
    
    % Sign of the vertical difference between the node on the upper contour
    % of the adapted model and the corresponding insertion nodes on the incisor
    signe_new = sign((Y_repos_new(i, nColTongueMesh) - Y_repos_new(i, 1)));
    % Sign of the vertical difference between the node on the upper contour of
    % YPM and the corresponding insertion nodes on the incisor
    signe_mod = sign((Y_repos(i, nColTongueMesh)-Y_repos(i, 1)));
    % Angle of the line joining the node on the mri tongue surface
    % and the corresponding insertion nodes on the incisor
    angleMRI = signe_new * ...
        acos((X_repos_new(i, nColTongueMesh) - X_repos_new(i, 1)) / lengthFirstFiberGGMRI);
    % Angle of the line joining the node on the upper contour of YPM and the
    % corresponding insertion nodes on the incisor
    angleGeneric = signe_mod * ...
        acos((X_repos(i, nColTongueMesh) - X_repos(i, 1)) / lengthFirstFiberGGGeneric);
    % The difference between these two angles is a measure of the global
    % rotation of the current line
    angle_rotat = angleMRI - angleGeneric;
    
% % %     % Plot the nodes on the lowest line in the adapted model
% % %     plot(X_repos_new(i, 1), Y_repos_new(i, 1), '+r', 'Linewidth',2)
% % %     
% % %     plot(ggOriginH_mri(1), ggOriginH_mri(2),'or','Linewidth',3)
% % %     
    
    distTmp = nan(1, nColTongueMesh-1);
    signTmp = nan(1, nColTongueMesh-1);
    angle_intern = nan(1, nColTongueMesh-1);
    angle_final = nan(1, nColTongueMesh-1);
    for j = 2:nColTongueMesh-1
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
p1 = [X_repos_new(1, nColTongueMesh); Y_repos_new(1, nColTongueMesh)];
p2 = [X_repos_new(1, 1); Y_repos_new(1, 1)];
lengthFirstFiberGGMRI = points_dist_nd(2, p1', p2');
% the same for the generic model
p1 = [X_repos(1, nColTongueMesh); Y_repos(1, nColTongueMesh)];
p2 = [tongInsLGeneric(1); Y_repos(1, 1)];
lengthFirstFiberGGGeneric = points_dist_nd(2, p1', p2');
distRatioFirstFibers = lengthFirstFiberGGMRI / lengthFirstFiberGGGeneric;

% sign of the vertical difference between the node on the upper contour
% of the adapted model and the corresponding insertion nodes on the incisor
signe_new = sign((Y_repos_new(1, nColTongueMesh)-Y_repos_new(1,1)));
% Sign of the vertical difference between the node on the upper contour of
% YPM and the corresponding insertion nodes on the incisor
signe_mod = sign((Y_repos(1, nColTongueMesh)-Y_repos(1,1)));
% Angle of the line joining the node on the upper contour of adapted model
% and the corresponding insertion nodes on the incisor
angleMRI = signe_new * ...
    acos((X_repos_new(1, nColTongueMesh) - X_repos_new(1,1)) / lengthFirstFiberGGMRI);
% Angle of the line joining the node on the upper contour of YPM and the
% corresponding insertion nodes on the incisor
angleGeneric = signe_mod * ...
    acos((X_repos(1, nColTongueMesh) - tongInsLGeneric(1)) / lengthFirstFiberGGGeneric);
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

