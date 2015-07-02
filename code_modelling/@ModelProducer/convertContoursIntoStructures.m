function structures = convertContoursIntoStructures( obj )
% convert contours into anatomical structures used by the VT model

    gridZoning = obj.gridZoning;

    innerPt = obj.contoursTransformed.innerPt;
    outerPt = obj.contoursTransformed.outerPt;

    % segment the inner contour
    structures.tongueSurface = ...
        innerPt(:, gridZoning.tongue(1):gridZoning.tongue(2));

    tongueLarynxTmp = innerPt(:, 1:gridZoning.palate(2));
    structures.tongueLarynx = fliplr(tongueLarynxTmp);

    % segment the outer contour
    larynxArytenoidTmp = outerPt(:, 1:gridZoning.pharynx(1));
    structures.larynxArytenoid = fliplr(larynxArytenoidTmp);

    backPharyngealWallTmp = ...
        outerPt(:, gridZoning.pharynx(1):gridZoning.pharynx(2));
    structures.backPharyngealWall = fliplr(backPharyngealWallTmp);

    % TODO: replace velum by a standard velum at some time 
    velumTmp = outerPt(:, gridZoning.velum(1):gridZoning.velum(2));
    structures.velum = fliplr(velumTmp);

    structures.palate = ...
        outerPt(1:2, gridZoning.palate(1):gridZoning.palate(2));

end
