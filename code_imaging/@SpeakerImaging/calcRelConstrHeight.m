function [height, ptConstrHeight] = calcRelConstrHeight(obj, ...
    innerPtGrdlineConstr, outerPtGrdlineConstr)
% determine relative constriction height parallel to back pharyngeal wall

ptPpdPharL_d = obj.landmarksDerivedMorpho.ppdPharL_d;
ptPharH_d = obj.landmarksDerivedMorpho.PharH_d;
ptPharL_d = obj.landmarksDerivedMorpho.PharL_d;

lenVertAbs = obj.measuresMorphology.lenVertAbs;

[~, ptConstrHeight] = lines_exp_int_2d(ptPharH_d', ptPharL_d', ...
    innerPtGrdlineConstr', outerPtGrdlineConstr');

lenConstrANSPNSAbs = points_dist_nd(2, ptPpdPharL_d', ptConstrHeight);

relHeight =  1 - (lenConstrANSPNSAbs / lenVertAbs);

height = relHeight;

end
