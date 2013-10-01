function [height, bData] = determineRelConstrHeight(landmarksDerivedMorpho, ...
    innerPtGrdlineConstr, outerPtGrdlineConstr, lenVertAbs)

    pt_ppdPharL_d = landmarksDerivedMorpho.ppdPharL_d(2:3);
    pt_PharH_d = landmarksDerivedMorpho.PharH_d(2:3);
    pt_PharL_d = landmarksDerivedMorpho.PharL_d(2:3);

    [~, pt_h1] = lines_exp_int_2d(pt_PharH_d, pt_PharL_d, ...
        innerPtGrdlineConstr, outerPtGrdlineConstr);

    plot(pt_h1(1), pt_h1(2), 'mo')
    
    lenConstrANSPNSAbs = points_dist_nd(2, pt_ppdPharL_d, pt_h1);

    relHeight =  1 - (lenConstrANSPNSAbs / lenVertAbs);

    % assign output values ----------------------------------------------
    
    height = relHeight;
    bData.pt_h1 = pt_h1;
    
end