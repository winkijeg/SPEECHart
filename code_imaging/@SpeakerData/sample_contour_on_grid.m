function [xyOut] = sample_contour_on_grid(obj, pts_cont)

for nbGrdLine = 1:obj.grid.nGridlines

    pts_grd_tmp = ...
        [obj.grid.innerPt(1:2, nbGrdLine) obj.grid.outerPt(1:2, nbGrdLine)];

    [X0,Y0] = ...
        intersections(pts_grd_tmp(1,:),pts_grd_tmp(2,:),pts_cont(1,:),pts_cont(2,:),'ROBUST');
    
    if ~(isempty(X0) || isempty(Y0))
        xyOut(1, nbGrdLine) = X0(1);
        xyOut(2, nbGrdLine) = Y0(1);
    else
        xyOut(1, nbGrdLine) = NaN;
        xyOut(2, nbGrdLine) = NaN;
    end
    
end
