function obj = calcLandmarksGrid(obj)
% calculate anatomical landmarks neccessary for semipolar grid generation

    p_AlvRidge = obj.xyAlvRidge;
    p_Palate = obj.xyPalate;
    p_PharH_d = obj.xyPharH_d;

    % calculate midpointCircle, the center of a circle intersecting the
    % landmarks p_AlvRidge, p_Palate, p_PharH_d
    pointsTmp = [p_AlvRidge p_Palate p_PharH_d];
    [~, midPoint2D(:, 1)] = triangle_circumcircle_2d(pointsTmp);

    obj.xyCircleMidpoint = midPoint2D;

end
