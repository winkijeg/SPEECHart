function anatomicalStructures = convertContoursIntoStructures( obj )
% create anatomical structures from inner and outer contours

gridZoning = obj.gridZoning;

innerPt = obj.contoursTransformed.innerPt;
outerPt = obj.contoursTransformed.outerPt;

% segment the inner contour
anatomicalStructures.tongueSurface = ...
    innerPt(:, gridZoning.tongue(1):gridZoning.tongue(2));

tongueLarynxTmp = innerPt(:, 1:gridZoning.palate(2));
anatomicalStructures.tongueLarynx = fliplr(tongueLarynxTmp);

% segment the outer contour
larynxArytenoidTmp = outerPt(:, 1:gridZoning.pharynx(1));
anatomicalStructures.larynxArytenoid = fliplr(larynxArytenoidTmp);

backPharyngealWallTmp = outerPt(:, gridZoning.pharynx(1):gridZoning.pharynx(2));
anatomicalStructures.backPharyngealWall = fliplr(backPharyngealWallTmp);

% \todo : replace velum by a standard velum at some time 
velumTmp = outerPt(:, gridZoning.velum(1):gridZoning.velum(2));
anatomicalStructures.velum = fliplr(velumTmp);

anatomicalStructures.palate = outerPt(1:2, gridZoning.palate(1):gridZoning.palate(2));

end
