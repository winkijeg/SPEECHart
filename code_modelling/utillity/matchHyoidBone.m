function strucTrans = matchHyoidBone(firstFiberGEN, firstFiberMRI, strucGEN)
% adapt hyoid bone position according to the position in the generic model
%   the first point of hyoid bone (hyoA) is transformed to the final
%   position and afterwards the two remaining points are positioned while
%   preserving the hyoid bone structure from the generic model

turnAngleGeneric = 3.0022; % generic turn angle (downwards) in degrees 

ptOriginFirstFiberGEN = firstFiberGEN(1:2, 1);
ptEndFirstFiberGEN = firstFiberGEN(1:2, 2);

ptOriginFirstFiberMRI = firstFiberMRI(1:2, 1);
ptEndFirstFiberMRI = firstFiberMRI(1:2, 2);

hyoAGeneric = strucGEN.hyoA;
hyoBGeneric = strucGEN.hyoB;
hyoCGeneric = strucGEN.hyoC;

% calculate length ratio
lengthGEN = points_dist_nd(2, ptEndFirstFiberGEN', ptOriginFirstFiberGEN');
lengthMRI = points_dist_nd(2, ptEndFirstFiberMRI', ptOriginFirstFiberMRI');
distRatioFirstFiber = lengthMRI / lengthGEN;
distOriginToHyoAGEN = points_dist_nd(2, ptOriginFirstFiberGEN, hyoAGeneric);

% calculate angle
rotationResultingFromFirstFiber = angle_deg_2d( ...
    [ptEndFirstFiberMRI(1) ptOriginFirstFiberMRI(2)]', ...
    ptOriginFirstFiberMRI', ptEndFirstFiberMRI');

angleRotFinal = -1 * (rotationResultingFromFirstFiber + turnAngleGeneric);

transVector1 = [0; distRatioFirstFiber*distOriginToHyoAGEN; 0];
transVector2 = [0; ptOriginFirstFiberMRI];


ptHyoATmp3D(:, 1) = [0 0 0];

t1 = tmat_init();
t2 = tmat_trans(t1, transVector1');
t3 = tmat_rot_axis(t2, angleRotFinal, 'X');
t4 = tmat_trans(t3, transVector2');

% transform first hyoid bone point (origin of hyoid bone)
ptHyoA3DTrans = tmat_mxp2(t4, 1, ptHyoATmp3D);
strucTrans.hyoA = ptHyoA3DTrans(2:3, 1);
% copy remaining to points while preserving hyoid bone structure
strucTrans.hyoB = ptHyoA3DTrans(2:3, 1) + hyoBGeneric - hyoAGeneric;
strucTrans.hyoC = ptHyoA3DTrans(2:3, 1) + hyoCGeneric - hyoAGeneric;

end
