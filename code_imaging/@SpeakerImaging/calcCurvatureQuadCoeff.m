function [val, basicData] = calcCurvatureQuadCoeff(innerPtPart)
% determine curvature by means of curve fitting (quadratic approximation)

nPointsPart = size(innerPtPart, 2);

% determine contour length in mm
lenCont = 0;
for k = 2:nPointsPart
    p1 = innerPtPart(1:2, k-1);
    p2 = innerPtPart(1:2, k);
    lenCont = lenCont + points_dist_nd(2, p1, p2);
end

% determine number of points; point to point distance is 1mm
nPointsPartSubSampl = round(lenCont);

innerPtPartSubSampl(1:2, :) = curvspace(innerPtPart', nPointsPartSubSampl)';

% indice of the origin (rotation)
% which roughly approximates the constriction location
indexRotationPoint = round(nPointsPartSubSampl / 2);

% calculate rotation angle
ptStartSubSampl(2:3) = innerPtPartSubSampl(1:2, 1);
ptMidSubSampl(2:3) = innerPtPartSubSampl(1:2, indexRotationPoint);
ptEndSubSampl(2:3) = innerPtPartSubSampl(1:2, end);

innerPtSubSampl3D(2:3, :) = innerPtPartSubSampl(1:2, :);

angleTmp = vector_directions_nd(3, ptEndSubSampl'-ptStartSubSampl');
angleRot = radians_to_degrees(angleTmp(2));

% transform to enable quadratic function approximation
tMat = tmat_init;
tMat = tmat_trans(tMat, -ptMidSubSampl);
tMat = tmat_rot_axis(tMat, -angleRot, 'X');

% transform points
innerPtSubSampl3DTrans = tmat_mxp2(tMat, nPointsPartSubSampl, ...
    innerPtSubSampl3D);

% approximate quadratic function
polynomialCoeff = polyfit(innerPtSubSampl3DTrans(2, :), ...
    innerPtSubSampl3DTrans(3, :), 2);

xMin = innerPtSubSampl3DTrans(2, 1);
xMax = innerPtSubSampl3DTrans(2, nPointsPartSubSampl);

xValsNew = xMin:0.1:xMax;
yValsNew = polyval(polynomialCoeff, xValsNew);
nVals = length(xValsNew);

contPartApproximated(1:3, :) = [zeros(1, nVals); xValsNew; yValsNew];

tMatInv = inv(tMat);
contPartApproximatedTransTmp(1:3, :) = tmat_mxp2(tMatInv, nVals, ...
    contPartApproximated);

val = polynomialCoeff(1);
basicData.contPartApproximated = contPartApproximatedTransTmp(2:3, :);

end
