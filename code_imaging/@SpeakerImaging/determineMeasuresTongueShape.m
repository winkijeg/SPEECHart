function obj = determineMeasuresTongueShape(obj)
% determine measures related to the tongue surface (vowel /a/ only)

if (strcmp(obj.phoneme, 'a') == false)
    errorStr = 'SO FAR the m-file %s makes sence for /a/ only ... ';
    error( errorStr, mfilename);
end

innerPt = obj.filteredContours.innerPt;
landmarksDerivedMorpho = obj.landmarksDerivedMorpho;
gridZoning = obj.gridZoning;

% extract relevant part of the tongue contour
ptPharH_d(1:2, 1) = landmarksDerivedMorpho.PharH_d;
ptPharL_d(1:2, 1) = landmarksDerivedMorpho.PharL_d;

% extract tongue back contour (feasable part)
indexStart = gridZoning.tongue(1) + 1;

ptContStart = innerPt(1:2, indexStart);

distancePtStartPharWall = line_exp_point_dist_2d(ptPharH_d', ptPharL_d', ...
    ptContStart');

% find end point of the relevant part of the contour
hasNext = 1;
indexTmp = indexStart + 1;

while hasNext
    
    ptTongTmp(1:2, 1) = innerPt(1:2, indexTmp);
    distanceTmp = line_exp_point_dist_2d(ptPharH_d', ptPharL_d', ptTongTmp');
    
    if ((distancePtStartPharWall - distanceTmp) > 0)
        hasNext = 1;
        indexTmp = indexTmp + 1;
    else
        hasNext = 0;
    end
    
end

indexEnd = indexTmp;

innerPtPart = innerPt(1:2, indexStart:indexEnd);

nPointsPart = indexEnd - indexStart + 1;

ptContMid = innerPtPart(1:2, round(nPointsPart / 2));
ptContEnd = innerPtPart(1:2, nPointsPart);

% start calculating tongue back curvature
[curvInvRadius, bDataInvRadius] = ...
    obj.determineCurvatureInvRadius(ptContStart, ptContMid, ptContEnd);

% start calculating quadratic approximation
[curvQuadCoeff, bDataQuadCoeff] = ...
    obj.determineCurvatureQuadCoeff(innerPtPart);

% start calculating tongue length
indexTongueStart = obj.gridZoning.tongue(1);
indexTongueEnd = obj.gridZoning.tongue(2);

[tongueLength, bDataTongLength] = ...
    obj.determineTongueLength(innerPt, indexTongueStart, indexTongueEnd);

obj.measuresTongueShape.curvatureInversRadius = curvInvRadius;
obj.measuresTongueShape.curvatureQuadCoeff = curvQuadCoeff;
obj.measuresTongueShape.tongueLength = tongueLength;

obj.UserData.invRadius = bDataInvRadius;
obj.UserData.quadCoeff = bDataQuadCoeff;
obj.UserData.tongLength = bDataTongLength;

end
