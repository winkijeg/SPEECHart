function grid_pt_complete = hasGridPoints(obj)
%Check if all points for grid specification has values

    hasValueLx = sum(isnan(obj.xyLx)) == 0;
    hasValuePalate = sum(isnan(obj.xyPalate)) == 0;
    hasValueAlvRidge = sum(isnan(obj.xyAlvRidge)) == 0;
    hasValueLipU = sum(isnan(obj.xyLipU)) == 0;
    hasValueLipL = sum(isnan(obj.xyLipL)) == 0;
    hasValuePharL = sum(isnan(obj.xyPharL)) == 0;
    hasValuePharH = sum(isnan(obj.xyPharH)) == 0;
    hasValueANS = sum(isnan(obj.xyANS)) == 0;
    hasValuePNS = sum(isnan(obj.xyANS)) == 0;

    grid_pt_complete = hasValueLx && hasValuePalate && hasValueAlvRidge && ...
        hasValueLipU && hasValueLipL && hasValuePharL && hasValuePharH && ...
        hasValueANS && hasValuePNS;

end

