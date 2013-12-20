function [val, basicData] = determineCurvatureInvRadius(ptStart, ptMid, ptEnd)

    val = segments_curvature_2d(ptStart', ptMid', ptEnd'); 

    basicData.ptStart = ptStart;
    basicData.ptMid = ptMid;
    basicData.ptEnd = ptEnd;

end

