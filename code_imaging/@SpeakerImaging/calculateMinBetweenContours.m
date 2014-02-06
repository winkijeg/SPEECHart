function [valMin, indMin] = calculateMinBetweenContours(innerCont, outerCont)
% calculate minimal constriction width between inner and outer VT contour

nPoints = size(innerCont, 2);

distances = nan(1, nPoints);
for k = 1:nPoints
    
    pt1 = innerCont(1:2, k);
    pt2 = outerCont(1:2, k);
    
    distances(k) = points_dist_nd(2, pt1', pt2');
    
end

[valMin, indMin] = min(distances);

end
