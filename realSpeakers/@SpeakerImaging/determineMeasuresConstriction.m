function obj = determineMeasuresConstriction(obj)


    % check phoneme because so far that measures make sense for /a/ only!
    if (strcmp(obj.phoneme, 'a') == false)
        
        str1 = 'SO FAR the m-file %s makes sence for /a/ only ... ';
        str2 = 'Do NOT use this method for other phonemes!';
        
        error( [str1 str2], mfilename);       
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
    
    [valMin, indMin] = obj.calculateMinBetweenContours(innerPtPart, outerPtPart);
    
    innerPtGrdlineConstr = innerPtPart(1:2, indMin);
    outerPtGrdlineConstr = outerPtPart(1:2, indMin);
    
    [hightRel, bData] = obj.determineRelConstrHeight(landmarksDerivedMorpho, ...
        innerPtGrdlineConstr, outerPtGrdlineConstr, lenVertAbs);
    
%     ptContStart = innerPtPart(1:2, 1);
%     ptContMid = innerPtPart(1:2, round(nPointsPart / 2));
%     ptContEnd = innerPtPart(1:2, nPointsPart);
%     
    % assign values --------------------------------------------------------
    measures.relativeConstrHeight = hightRel;
    measures.constrictionWidth = valMin;
    
    obj.measuresConstriction = measures;
    obj.UserData.relConstrHeight = bData;
    
end
