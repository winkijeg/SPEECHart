function obj = determineMeasuresConstriction(obj)
% determine measures related to the vowel constriction (vowel /a/ only)

if (strcmp(obj.phoneme, 'a') == false)
    errorStr = 'SO FAR the m-file %s makes sence for /a/ only ... ';
    error( errorStr, mfilename);
end

innerPt = obj.filteredContours.innerPt;
outerPt = obj.filteredContours.outerPt;
gridZoning = obj.gridZoning;


% extract relevant contours (feasable part)
indexStart = gridZoning.pharynx(1);
indexEnd = gridZoning.pharynx(2);

innerPtPart = innerPt(1:2, indexStart:indexEnd);
outerPtPart = outerPt(1:2, indexStart:indexEnd);

[valMin, indMin] = findMinDistanceBetweenTwoLines(innerPtPart, outerPtPart);

innerPtGrdlineConstr = innerPtPart(1:2, indMin);
outerPtGrdlineConstr = outerPtPart(1:2, indMin);

[hightRel, ptConstrHeight] = calcRelConstrHeight(obj, ...
    innerPtGrdlineConstr, outerPtGrdlineConstr);

measures.relativeConstrHeight = hightRel;
measures.constrictionWidth = valMin;

obj.measuresConstriction = measures;
obj.UserData.relConstrHeight.ptConstrHeight = ptConstrHeight;

end
