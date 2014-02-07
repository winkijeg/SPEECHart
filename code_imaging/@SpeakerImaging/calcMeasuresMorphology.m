function measuresMorphology = calcMeasuresMorphology( obj )
% calculate morphological measures related to the specific speaker

ptANS = obj.landmarks.ANS;
ptNPW_d = obj.landmarksDerivedMorpho.NPW_d;
ptPpdPharL_d = obj.landmarksDerivedMorpho.ppdPharL_d;
ptPharL = obj.landmarks.PharL;

ptPNS = obj.landmarks.PNS;
ptAlvRidge = obj.landmarks.AlvRidge;
ptPalate = obj.landmarks.Palate;

% original ratio measurement
lenHoriAbs = points_dist_nd(2, ptANS', ptNPW_d');

% calculate alternative pharynx lengths
lenVertAbs = line_exp_point_dist_2d(ptANS', ptPpdPharL_d', ptPharL');

ratioVH = lenVertAbs / lenHoriAbs;


% calculate palate steepness (by means of an angle)
ptHelp1(:, 1) = line_exp_point_near_2d(ptANS', ptPNS', ptAlvRidge');

palateAngleDegree = angle_deg_2d(ptHelp1', ptAlvRidge', ptPalate');

% -------------- assignments ------------------------------------------
measuresMorphology.lenHoriAbs = lenHoriAbs;
measuresMorphology.lenVertAbs = lenVertAbs;
measuresMorphology.ratioVH = ratioVH;
measuresMorphology.palateAngle = palateAngleDegree;

end
