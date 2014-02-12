function strucTransformed = transformSpeakerData( obj, strucOrig, tMat)
% transform extracted speaker data given a transformation matrix


% trandform landmarks
tongInsL3D = [0; strucOrig.tongInsL];
tongInsH3D = [0; strucOrig.tongInsH];
styloidProcess3D = [0; strucOrig.styloidProcess];
condyle3D = [0; strucOrig.condyle];
ANS3D = [0; strucOrig.ANS];
PNS3D = [0; strucOrig.PNS];


tongInsLTrans = tmat_mxp(tMat, tongInsL3D);
tongInsHTrans = tmat_mxp(tMat, tongInsH3D);
styloidProcessTrans = tmat_mxp(tMat, styloidProcess3D);
condyleTrans = tmat_mxp(tMat, condyle3D);
ANSTrans = tmat_mxp(tMat, ANS3D);
PNSTrans = tmat_mxp(tMat, PNS3D);

strucTransformed.tongInsL(1:2, 1) = tongInsLTrans(2:3);
strucTransformed.tongInsH(1:2, 1) = tongInsHTrans(2:3);
strucTransformed.styloidProcess(1:2, 1) = styloidProcessTrans(2:3);
strucTransformed.condyle(1:2, 1) = condyleTrans(2:3);
strucTransformed.ANS(1:2, 1) = ANSTrans(2:3);
strucTransformed.PNS(1:2, 1) = PNSTrans(2:3);

% transform the two contours
innerPt2D = strucOrig.innerPt;
outerPt2D = strucOrig.outerPt;

nPointsOuter = size(innerPt2D, 2);
nPointsInner = size(outerPt2D, 2);

innerPt3D = [zeros(1, nPointsInner); innerPt2D];
outerPt3D = [zeros(1, nPointsOuter); outerPt2D];

innerPt3DTrans = tmat_mxp2(tMat, nPointsInner, innerPt3D);
outerPt3DTrans = tmat_mxp2(tMat, nPointsOuter, outerPt3D);

strucTransformed.innerPt = innerPt3DTrans(2:3, :);
strucTransformed.outerPt = outerPt3DTrans(2:3, :);

end
