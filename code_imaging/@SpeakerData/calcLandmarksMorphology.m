function obj = calcLandmarksMorphology(obj)
% calculate derived landmarks neccessary for morphological measures

% TODO: test if ALL necessary landmarks are available

    ptANS = obj.xyANS;
    ptPNS = obj.xyPNS;
    ptVallSin = obj.xyVallSin;
    ptAlvRidge = obj.xyAlvRidge;
    ptPharH = obj.xyPharH;
    ptPharL = obj.xyPharL;

    % ptPharHTmp_d (temporary) is the 4th point of the parallelogramm
    % ANS-AlvRidge-h3-PNS
    ptPharHTmp_d = -ptANS + ptAlvRidge + ptPNS;
    % ptPharH_d is the intersection point between two lines: (1) back
    % pharyngeal wall and (2) the line passing p1 and is parralel to ANS-PNS
    [~, pt_PharH_d(:, 1)] = lines_exp_int_2d(...
        ptAlvRidge', ptPharHTmp_d', ptPharH', ptPharL');

    % ptPharLTmp_d (temporary) is the 4th point of the parallelogramm
    % ANS-Hyo-h4-PNS
    ptPharLTmp_d = -ptANS + ptVallSin + ptPNS;
    % ptPharL_d is the intersection point between two lines: (1) back
    % pharyngeal wall and (2) the line passing Hyo and is parralel to ANS-PNS
    [~, pt_PharL_d(:, 1)] = lines_exp_int_2d(...
        ptVallSin', ptPharLTmp_d', ptPharH', ptPharL');

    % find two derived points (for morpological analysis)
    % (1) intersection point of palatal plane and pharynx wall
    [~, ptNPW(:, 1)] = lines_exp_int_2d(...
        ptANS', ptPNS', pt_PharL_d', pt_PharH_d');

    % (2) shortest distance from pt_PharL_d to palatal plane
    ptPpdPharL_d(:, 1) = line_exp_perp_2d(ptANS', ptPNS', pt_PharL_d');

    % assign values -------------------------------------------
    obj.xyPharH_d = pt_PharH_d;
    obj.xyPharL_d = pt_PharL_d;
    obj.xyNPW_d = ptNPW;
    obj.xyPPDPharL_d = ptPpdPharL_d;

end
