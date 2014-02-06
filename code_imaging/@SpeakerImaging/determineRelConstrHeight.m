function [height, UserData] = determineRelConstrHeight(landmarksDerivedMorpho, ...
    innerPtGrdlineConstr, outerPtGrdlineConstr, lenVertAbs)
% determine relative constriction height parallel to back pharyngeal wall

ptPpdPharL_d = landmarksDerivedMorpho.ppdPharL_d;
ptPharH_d = landmarksDerivedMorpho.PharH_d;
ptPharL_d = landmarksDerivedMorpho.PharL_d;

[~, ptConstrHeight] = lines_exp_int_2d(ptPharH_d', ptPharL_d', ...
    innerPtGrdlineConstr', outerPtGrdlineConstr');

lenConstrANSPNSAbs = points_dist_nd(2, ptPpdPharL_d', ptConstrHeight);

relHeight =  1 - (lenConstrANSPNSAbs / lenVertAbs);

height = relHeight;
UserData.ptConstrHeight = ptConstrHeight;

end