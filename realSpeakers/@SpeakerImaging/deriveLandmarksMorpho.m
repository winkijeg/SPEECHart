function landmarksDerived = deriveLandmarksMorpho(obj)

    pt_ANS = obj.landmarks.ANS;
    pt_PNS = obj.landmarks.PNS;
    pt_VallSin = obj.landmarks.VallSin;
    pt_AlvRidge = obj.landmarks.AlvRidge;
    pt_PharH = obj.landmarks.PharH;
    pt_PharL = obj.landmarks.PharL;

    valLR = obj.landmarks.ANS(1);

    % ptPharHTmp_d (temporary) is the 4th point of the parallelogramm 
    % ANS-AlvRidge-h3-PNS
    ptPharHTmp_d = -pt_ANS + pt_AlvRidge + pt_PNS;
    % ptPharH_d is the intersection point between two lines: (1) back 
    % pharyngeal wall and (2) the line passing p1 and is parralel to ANS-PNS
    [~, pt_PharH_d] = lines_exp_int_2d(pt_AlvRidge(2:3), ptPharHTmp_d(2:3), ...
        pt_PharH(2:3), pt_PharL(2:3));

    % ptPharLTmp_d (temporary) is the 4th point of the parallelogramm 
    % ANS-Hyo-h4-PNS
    ptPharLTmp_d = -pt_ANS + pt_VallSin + pt_PNS;
    % ptPharL_d is the intersection point between two lines: (1) back 
    % pharyngeal wall and (2) the line passing Hyo and is parralel to ANS-PNS
    [~, pt_PharL_d] = lines_exp_int_2d(pt_VallSin(2:3), ptPharLTmp_d(2:3), ...
        pt_PharH(2:3), pt_PharL(2:3));

    % find two derived points (for morpological analysis)
    % (1) intersection point of palatal plane and pharynx wall
    [~, pt_NPW] = lines_exp_int_2d (pt_ANS(2:3), pt_PNS(2:3), ...
        pt_PharL_d, pt_PharH_d);

    % (2) shortest distance from pt_PharL_d to palatal plane
    pt_ppdPharL_d = line_exp_perp_2d (pt_ANS(2:3), pt_PNS(2:3),...
        pt_PharL_d);

    % assign values -------------------------------------------
    landmarksDerived.PharH_d = [valLR pt_PharH_d];
    landmarksDerived.PharL_d = [valLR pt_PharL_d];
    landmarksDerived.NPW_d = [valLR pt_NPW];
    landmarksDerived.ppdPharL_d = [valLR pt_ppdPharL_d];

end

