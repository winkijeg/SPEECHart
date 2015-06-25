function gridData = getDataForGrid( obj )
% format speaker-data for semi-polar grid generation

    gridData.xyAlvRidge = obj.xyAlvRidge;
    gridData.xyPalate = obj.xyPalate;
    gridData.xyPharH = obj.xyPharH;
    gridData.xyPharL = obj.xyPharL;
    gridData.xyLx = obj.xyLx;
    gridData.xyLipU = obj.xyLipU;
    gridData.xyLipL = obj.xyLipL;
    gridData.xyCircleMidpoint = obj.xyCircleMidpoint;

end
