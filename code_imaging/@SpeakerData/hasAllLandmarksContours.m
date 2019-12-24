function hasValues = hasAllLandmarksContours(obj)
%check if all landmarks and sampled contours exist
    
    hasGrdPoints = obj.hasGridPoints();
                
    hasValStyloidProcess = sum(isnan(obj.xyStyloidProcess)) == 0;
    hasValTongInsL = sum(isnan(obj.xyTongInsL)) == 0;
    hasValTongInsH = sum(isnan(obj.xyTongInsH)) == 0;
    hasValVallSin = sum(isnan(obj.xyVallSin)) == 0;
    hasValTongTip = sum(isnan(obj.xyTongTip)) == 0;
    hasValVelum = sum(isnan(obj.xyVelum)) == 0;
    
    hasInnerCont = obj.hasSampledContour('inner');
    hasOuterCont = obj.hasSampledContour('outer');
    
    hasValues = hasGrdPoints && hasValStyloidProcess && hasValTongInsL ...
        && hasValTongInsH && hasValVallSin && hasValTongTip && hasInnerCont ...
        && hasValVelum && hasOuterCont; 

end

