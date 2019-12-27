function [ptInnerNew, ptOuterNew] = ...
    get_grdLine_Translation(ptInner, ptOuter, myDist, pt_rot, vec_trans, anglDeg)

tMat = tmat_init;

% translate, i.e. 3 mm upward
tMat = tmat_trans(tMat, [0 0 myDist]);
% translate to origin
tMat = tmat_trans(tMat, -vec_trans');
% rotate
tMat = tmat_rot_axis(tMat, -anglDeg, 'X');
% translate
tMat = tmat_trans(tMat, pt_rot');

% transform points
ptInnerNew = tmat_mxp(tMat, ptInner);
ptOuterNew = tmat_mxp(tMat, ptOuter);