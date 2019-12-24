function hasValues = hasRawContour(obj, contName)
%Check if raw contour has values

    if strcmp(contName, 'inner')
        hasValues = sum(sum(isnan(obj.xyInnerTrace_raw))) == 0;
    else
        hasValues = sum(sum(isnan(obj.xyOuterTrace_raw))) == 0;
    end

end
