function [valMin, indMin] = findMinDistanceBetweenTwoLines(line1, Line2)
% calculate minimal distance between two lines of equal length

nPoints = size(line1, 2);

distances = nan(1, nPoints);
for k = 1:nPoints
    
    pt1 = line1(1:2, k);
    pt2 = Line2(1:2, k);
    
    distances(k) = points_dist_nd(2, pt1', pt2');
    
end

[valMin, indMin] = min(distances);

end
