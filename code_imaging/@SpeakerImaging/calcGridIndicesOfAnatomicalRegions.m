function gridZoning = calcGridIndicesOfAnatomicalRegions(obj)
% split inner and outer contours into anatomical motivated parts
%   The INNER contour is labels as:
%   - tongue surface between two landmarks (VallSin - TongTip).
%
%   The OUTER contour is partinioned into three parts:
%   - back pharyngeal wall (PharL - PharH)
%   - velum (PharH - Velum)
%   - palate (Velume - Palate)

grd = obj.semipolarGrid;

% anatomical landmarks necessary to zone the contours
ptTongStart = obj.landmarks.VallSin;
ptTongEnd = obj.landmarks.TongTip;

ptPharStart = obj.landmarks.PharL;
ptPharEnd = obj.landmarks.PharH;

ptVelumStart = obj.landmarks.PharH;
ptVelumEnd = obj.landmarks.Velum;

ptPalateStart = obj.landmarks.Velum;
ptPalateEnd = obj.landmarks.AlvRidge;

% memory allocation
distGrdLineTargetLandmarkTongStart = ones(1, grd.numberOfGridlines) * NaN;
distGrdLineTargetLandmarkTongEnd = ones(1, grd.numberOfGridlines) * NaN;
distGrdLineTargetLandmarkPharStart = ones(1, grd.numberOfGridlines) * NaN;
distGrdLineTargetLandmarkPharEnd = ones(1, grd.numberOfGridlines) * NaN;
distGrdLineTargetLandmarkVelumStart = ones(1, grd.numberOfGridlines) * NaN;
distGrdLineTargetLandmarkVelumEnd = ones(1, grd.numberOfGridlines) * NaN;
distGrdLineTargetLandmarkPalateStart = ones(1, grd.numberOfGridlines) * NaN;
distGrdLineTargetLandmarkPalateEnd = ones(1, grd.numberOfGridlines) * NaN;

for k = 1:grd.numberOfGridlines
    
    ptGrdInner = grd.innerPt(1:2, k)';
    ptGrdOuter = grd.outerPt(1:2, k)';
    
    distGrdLineTargetLandmarkTongStart(k) = segment_point_dist_2d(ptGrdInner, ...
        ptGrdOuter, ptTongStart');
    distGrdLineTargetLandmarkTongEnd(k) = segment_point_dist_2d(ptGrdInner, ...
        ptGrdOuter, ptTongEnd');
    distGrdLineTargetLandmarkPharStart(k) = segment_point_dist_2d(ptGrdInner, ...
        ptGrdOuter, ptPharStart');
    distGrdLineTargetLandmarkPharEnd(k) = segment_point_dist_2d(ptGrdInner, ...
        ptGrdOuter, ptPharEnd');
    distGrdLineTargetLandmarkVelumStart(k) = segment_point_dist_2d(ptGrdInner, ...
        ptGrdOuter, ptVelumStart');
    distGrdLineTargetLandmarkVelumEnd(k) = segment_point_dist_2d(ptGrdInner, ...
        ptGrdOuter, ptVelumEnd');
    distGrdLineTargetLandmarkPalateStart(k) = segment_point_dist_2d(ptGrdInner, ...
        ptGrdOuter, ptPalateStart');
    distGrdLineTargetLandmarkPalateEnd(k) = segment_point_dist_2d(ptGrdInner, ...
        ptGrdOuter, ptPalateEnd');
end


[~, indMinTongStart] = min(distGrdLineTargetLandmarkTongStart);
[~, indMinTongEnd] = min(distGrdLineTargetLandmarkTongEnd);

[~, indMinPharStart] = min(distGrdLineTargetLandmarkPharStart);
[~, indMinPharEnd] = min(distGrdLineTargetLandmarkPharEnd);

[~, indMinVelumStart] = min(distGrdLineTargetLandmarkVelumStart);
[~, indMinVelumEnd] = min(distGrdLineTargetLandmarkVelumEnd);

[~, indMinVelPalateStart] = min(distGrdLineTargetLandmarkPalateStart);
[~, indMinPalateEnd] = min(distGrdLineTargetLandmarkPalateEnd);

% assign values to the output structure
gridZoning.tongue = [indMinTongStart indMinTongEnd];
gridZoning.pharynx = [indMinPharStart indMinPharEnd];
gridZoning.velum = [indMinVelumStart indMinVelumEnd];
gridZoning.palate = [indMinVelPalateStart indMinPalateEnd];

end
