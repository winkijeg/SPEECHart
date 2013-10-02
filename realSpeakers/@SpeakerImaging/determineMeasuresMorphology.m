function measuresMorphology = determineMeasuresMorphology( obj )

    pt_ANS = obj.landmarks.ANS;
    pt_NPW_d = obj.landmarksDerivedMorpho.NPW_d;
    pt_ppdPharL_d = obj.landmarksDerivedMorpho.ppdPharL_d;
    pt_PharL = obj.landmarks.PharL;
    
    pt_PNS = obj.landmarks.PNS;
    pt_AlvRidge = obj.landmarks.AlvRidge;
    pt_Palate = obj.landmarks.Palate;

    % original ratio measurement
    lenHoriAbs = points_dist_nd(2, pt_ANS(2:3), pt_NPW_d(2:3));

    % calculate alternative pharynx lengths
    lenVertAbs = line_exp_point_dist_2d(pt_ANS(2:3), ...
        pt_ppdPharL_d(2:3), pt_PharL(2:3));

    ratioVH = lenVertAbs / lenHoriAbs;

    
    % calculate palate steepness (by means of an angle)
    pt_help1 = line_exp_point_near_3d (pt_ANS, pt_PNS, pt_AlvRidge);

    palateAngleDegree = angle_deg_2d(pt_help1(2:3), pt_AlvRidge(2:3), ...
        pt_Palate(2:3));
    

    % -------------- assignments ------------------------------------------
    measuresMorphology.lenHoriAbs = lenHoriAbs;
    measuresMorphology.lenVertAbs = lenVertAbs;
    measuresMorphology.ratioVH = ratioVH;
    measuresMorphology.palateAngle = palateAngleDegree;

end

