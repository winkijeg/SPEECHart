function [landmarksTrans, contourTrans] = transformSpeakerData( obj )
% transform extracted speaker data given a transformation matrix

    tMat = obj.tMatGeom;

    % trandform landmarks
    tongInsL3D = [0; obj.landmarks.xyTongInsL];
    tongInsH3D = [0; obj.landmarks.xyTongInsH];
    styloidProcess3D = [0; obj.landmarks.xyStyloidProcess];
    condyle3D = [0; obj.landmarks.xyCondyle];
    ANS3D = [0; obj.landmarks.xyANS];
    PNS3D = [0; obj.landmarks.xyPNS];
    origin3D = [0; obj.landmarks.xyOrigin];

    tongInsLTrans = tmat_mxp(tMat, tongInsL3D);
    tongInsHTrans = tmat_mxp(tMat, tongInsH3D);
    styloidProcessTrans = tmat_mxp(tMat, styloidProcess3D);
    condyleTrans = tmat_mxp(tMat, condyle3D);
    ANSTrans = tmat_mxp(tMat, ANS3D);
    PNSTrans = tmat_mxp(tMat, PNS3D);
    originTrans = tmat_mxp(tMat, origin3D);

    landmarksTrans.tongInsL(1:2, 1) = tongInsLTrans(2:3);
    landmarksTrans.tongInsH(1:2, 1) = tongInsHTrans(2:3);
    landmarksTrans.styloidProcess(1:2, 1) = styloidProcessTrans(2:3);
    landmarksTrans.condyle(1:2, 1) = condyleTrans(2:3);
    landmarksTrans.ANS(1:2, 1) = ANSTrans(2:3);
    landmarksTrans.PNS(1:2, 1) = PNSTrans(2:3);
    landmarksTrans.origin(1:2, 1) = originTrans(2:3);

    % transform the two contours
    innerPt2D = obj.contours.innerPt;
    outerPt2D = obj.contours.outerPt;

    nPointsOuter = size(innerPt2D, 2);
    nPointsInner = size(outerPt2D, 2);

    innerPt3D = [zeros(1, nPointsInner); innerPt2D];
    outerPt3D = [zeros(1, nPointsOuter); outerPt2D];

    innerPt3DTrans = tmat_mxp2(tMat, nPointsInner, innerPt3D);
    outerPt3DTrans = tmat_mxp2(tMat, nPointsOuter, outerPt3D);

    contourTrans.innerPt = innerPt3DTrans(2:3, :);
    contourTrans.outerPt = outerPt3DTrans(2:3, :);

end
