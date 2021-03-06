function incisorMatched = matchLowerIncisor(tongInsL_mri, tongInsH_mri, scaleFactor)
% connect standard lower incisor with tongue with regard to incisor size

% the two indices split the incisor roughly into mental spine and real
% incisor. the lower part (in other words the mental spine part) is matched
% different from the part cooresponding to the incisor (teeth tip).

% load standard incisor 
mat = load('lowerIncisorStandard.mat');
incisor_standard = mat.lowerIncisorStandard;
nPtsIncisor_standard = length(incisor_standard(1, :));

tongInsH_standard = incisor_standard(1:2, 14);
tongInsL_standard = incisor_standard(1:2, 17);

% calculate rotation angle
angleIncisor_mri_deg = angle_deg_2d(tongInsH_mri, tongInsL_mri, ...
    [1000; tongInsL_mri(2)]);
angleIncisor_standard_deg = angle_deg_2d(tongInsH_standard, tongInsL_standard, ...
    [1000; tongInsL_standard(2)]);
angleRotation = angleIncisor_mri_deg - angleIncisor_standard_deg;


lowerIncisorTmp = nan(2, nPtsIncisor_standard);

% --- 1 ------------------------------------------------------------
% scale and rotate the region of the mental spine, which is the region for
% all genioglossus muscle fiber origins

ptPart1 = incisor_standard(1:2, 14:17);
ptPart1_3D = [zeros(1, 4); ptPart1];

scaleVec = [0 scaleFactor scaleFactor];

t1 = tmat_init();
t2 = tmat_scale(t1, scaleVec);
t3 = tmat_rot_axis(t2, angleRotation, 'X');
part1Trans = tmat_mxp2(t3, 4, ptPart1_3D);

lowerIncisorTmp(1:2, 14:17) = part1Trans(2:3, :);

% --- 2 -------------------------------------------------------------
for nbPoint = 1:4

    indPtCorrespond = nPtsIncisor_standard-nbPoint+1;
    
    lowerIncisorTmp(1:2, nbPoint) = incisor_standard(1:2, nbPoint) - ...
        incisor_standard(1:2, indPtCorrespond) + ...
        lowerIncisorTmp(1:2, indPtCorrespond);
end

% --- 3 ------------------------------------------------------------
scaleTmp = min(1, scaleFactor);

for j = 6:13
    lowerIncisorTmp(1:2, j) = lowerIncisorTmp(1:2, 14) + ...
        scaleTmp * (incisor_standard(1:2, j) - incisor_standard(1:2, 14));
end

% --- 4 -------------------------------------------------------------
xValTmp = (lowerIncisorTmp(1, 4) + lowerIncisorTmp(1, 6)) / 2;
yValTmp = (lowerIncisorTmp(2, 4) + lowerIncisorTmp(2, 6)) / 2;
lowerIncisorTmp(1:2, 5) = [xValTmp; yValTmp];

% --- translate whole incisor to the attachment point ----------------
lowerIncisor3D = [zeros(1, nPtsIncisor_standard); lowerIncisorTmp];

t1 = tmat_init();
t2 = tmat_trans(t1, [0; tongInsL_mri]');
incisorTrans = tmat_mxp2(t2, nPtsIncisor_standard, lowerIncisor3D);
incisorMatched(1:2, :) = incisorTrans(2:3, :);

end
