function [val, basicData] = calcCurvatureInvRadius(ptStart, ptMid, ptEnd)
% determine curvature by means of invert radius of a circle crossing 3 points

val = segments_curvature_2d(ptStart', ptMid', ptEnd');

basicData.ptStart = ptStart;
basicData.ptMid = ptMid;
basicData.ptEnd = ptEnd;

end
