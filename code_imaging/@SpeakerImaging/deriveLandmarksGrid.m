function landmarksDerived = deriveLandmarksGrid(obj)

    p_AlvRidge = obj.landmarks.AlvRidge;
    p_Palate = obj.landmarks.Palate;
    p_PharH_d = obj.landmarksDerivedMorpho.PharH_d;
    
   
    % calculate midpointCircle, the center of a circle intersecting the 
    % landmarks p_AlvRidge, p_Palate, p_PharH_d
    pointsTmp = [p_AlvRidge p_Palate p_PharH_d];
    [~, midPoint2D(:, 1)] = triangle_circumcircle_2d(pointsTmp);
    
    % assign values -------------------------------------------
    landmarksDerived.circleMidpoint = midPoint2D;
  
end
