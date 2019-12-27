function hasValues = hasSampledContour(obj, contName)
%Check if sampled contour has values

    if strcmp(contName, 'inner')
        hasValues = sum(sum(isnan(obj.xyInnerTrace_sampl))) == 0;
    else
        hasValues = sum(sum(isnan(obj.xyOuterTrace_sampl))) == 0;
    end

end
