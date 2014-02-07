function obj = determineMeasuresConstriction(obj)
% determine measures related to the vowel constriction (vowel /a/ only)

if (strcmp(obj.phoneme, 'a') == false)
    errorStr = 'SO FAR the m-file %s makes sence for /a/ only ... ';
    error( errorStr, mfilename);
end

innerPt = obj.filteredContours.innerPt;
outerPt = obj.filteredContours.outerPt;
landmarksDerivedMorpho = obj.landmarksDerivedMorpho;
gridZoning = obj.gridZoning;

lenVertAbs = obj.measuresMorphology.lenVertAbs;

% extract relevant contours (feasable part) -------------------------
indexStart = gridZoning.pharynx(1);
indexEnd = gridZoning.pharynx(2);

innerPtPart = innerPt(1:2, indexStart:indexEnd);
outerPtPart = outerPt(1:2, indexStart:indexEnd);

[valMin, indMin] = findMinDistanceBetweenTwoLines(innerPtPart, outerPtPart);

innerPtGrdlineConstr = innerPtPart(1:2, indMin);
outerPtGrdlineConstr = outerPtPart(1:2, indMin);

[hightRel, bData] = obj.determineRelConstrHeight(landmarksDerivedMorpho, ...
    innerPtGrdlineConstr, outerPtGrdlineConstr, lenVertAbs);

% assign values --------------------------------------------------------
measures.relativeConstrHeight = hightRel;
measures.constrictionWidth = valMin;

obj.measuresConstriction = measures;
obj.UserData.relConstrHeight = bData;

end
