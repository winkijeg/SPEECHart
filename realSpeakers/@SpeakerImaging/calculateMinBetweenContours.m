function [valMin, indMin] = calculateMinBetweenContours(innerCont, outerCont)

    nPoints = size(innerCont, 2);
    
    distances = zeros(1, nPoints);
    for k = 1:nPoints
        
        p1 = innerCont(1:2, k);
        p2 = outerCont(1:2, k);
        
        distances(k) = points_dist_nd(2, p1', p2');
        
    end
    
    [valMin, indMin] = min(distances);

end

