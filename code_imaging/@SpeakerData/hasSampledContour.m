function hasValues = hasSampledContour(obj, contName)
%Check if raw contour has values

    if strcmp(contName, 'inner')
        hasValues = sum(sum(isnan(obj.xyInnerTrace_sampl))) == 0;
    else
        hasValues = sum(sum(isnan(obj.xyOuterTrace_sampl))) == 0;
    end

end
