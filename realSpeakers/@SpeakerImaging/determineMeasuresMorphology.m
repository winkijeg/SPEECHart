function measuresMorphology = determineMeasuresMorphology( obj )

    pt_ANS = obj.landmarks.ANS;
    pt_NPW_d = obj.landmarksDerivedMorpho.NPW_d;
    pt_ppdPharL_d = obj.landmarksDerivedMorpho.ppdPharL_d;
    pt_PharL = obj.landmarks.PharL;

    % original ratio measurement
    lenHoriAbs = points_dist_nd(2, pt_ANS(2:3), pt_NPW_d(2:3));

    % calculate alternative pharynx lengths
    lenVertAbs = line_exp_point_dist_2d(pt_ANS(2:3), ...
        pt_ppdPharL_d(2:3), pt_PharL(2:3));

    ratioVH = lenVertAbs / lenHoriAbs;

    % write structure with derived points and results
    measuresMorphology.lenHoriAbs = lenHoriAbs;
    measuresMorphology.lenVertAbs = lenVertAbs;
    measuresMorphology.ratioVH = ratioVH;

end

