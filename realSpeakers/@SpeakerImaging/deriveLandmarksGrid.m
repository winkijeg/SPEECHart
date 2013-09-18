function landmarksDerived = deriveLandmarksGrid(obj)

    p_ANS = obj.landmarks.ANS;
    p_AlvRidge = obj.landmarks.AlvRidge;
    p_Palate = obj.landmarks.Palate;
    p_PharH_d = obj.landmarksDerivedMorpho.PharH_d;
    
    % determine value for left-right dimension
    valLR = p_ANS(1);

    % calculate midpointCircle, the center of a circle intersecting the 
    % landmarks p_AlvRidge, p_Palate, p_PharH_d
    pointsTmp = [p_AlvRidge(2:3)' p_Palate(2:3)' p_PharH_d(2:3)'];
    [~, midPoint2D] = triangle_circumcircle_2d(pointsTmp);
    
    % assign values -------------------------------------------
    landmarksDerived.circleMidpoint = [valLR midPoint2D];
  
end

