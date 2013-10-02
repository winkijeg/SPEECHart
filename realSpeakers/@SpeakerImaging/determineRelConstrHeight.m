function [height, UserData] = determineRelConstrHeight(landmarksDerivedMorpho, ...
    innerPtGrdlineConstr, outerPtGrdlineConstr, lenVertAbs)

    pt_ppdPharL_d = landmarksDerivedMorpho.ppdPharL_d(2:3);
    pt_PharH_d = landmarksDerivedMorpho.PharH_d(2:3);
    pt_PharL_d = landmarksDerivedMorpho.PharL_d(2:3);

    [~, ptConstrHeight] = lines_exp_int_2d(pt_PharH_d, pt_PharL_d, ...
        innerPtGrdlineConstr, outerPtGrdlineConstr);

    lenConstrANSPNSAbs = points_dist_nd(2, pt_ppdPharL_d, ptConstrHeight);

    relHeight =  1 - (lenConstrANSPNSAbs / lenVertAbs);

    % assign output values ----------------------------------------------
    height = relHeight;
    UserData.ptConstrHeight = ptConstrHeight;
    
end