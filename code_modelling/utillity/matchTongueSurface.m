function tongSurfAdapted = matchTongueSurface(tongSurfaceGeneric, tongSurfMRIRaw)
% adapt MRI tongue surface with to the generic surface structure

nPointsTongSurfGeneric = size(tongSurfaceGeneric, 2);
nPointsTongSurfMRIRaw = size(tongSurfMRIRaw, 2);

xValsTmp = spline(1:nPointsTongSurfMRIRaw, tongSurfMRIRaw(1, :), ...
    1:1/10:nPointsTongSurfMRIRaw);
yValsTmp = spline(1:nPointsTongSurfMRIRaw, tongSurfMRIRaw(2, :), ...
    1:1/10:nPointsTongSurfMRIRaw);
tongSurfMRI = [xValsTmp; yValsTmp];
nPointsTongSurfMRISubSampled = size(tongSurfMRI, 2);

% computation of the piecewise length of the generic tongue contour
lenSegTongSurfGen = nan(1, nPointsTongSurfGeneric-1);
for k = 1:nPointsTongSurfGeneric-1
    lenSegTongSurfGen(k) = points_dist_nd (2, ...
        tongSurfaceGeneric(:, k), tongSurfaceGeneric(:, k+1));
end
lenTotTongSurfGen = sum(lenSegTongSurfGen);

% computation of the piecewise length of the mri tongue contour
lenSegTongSurfMRIOrig = nan(1, nPointsTongSurfMRISubSampled-1);
for k = 1:nPointsTongSurfMRISubSampled-1
    lenSegTongSurfMRIOrig(k) = points_dist_nd (2, ...
        tongSurfMRI(:, k), tongSurfMRI(:, k+1));
end
lenTotTongSurfMRI = sum(lenSegTongSurfMRIOrig);

% calculate the relative position of the nodes along the generic tongue surface. 
% the reference point is the first point of the
% surface located on the hyoid bone. The relative position of each surface node 
% is characterised by the ratio ratioRelPosGen of its distance to the 
% reference point divided by the total length of the tongue surface.

% for the first point the ratio is obviously 0
ratiosRelPosGeneric = nan(1, nPointsTongSurfGeneric);
ratiosRelPosGeneric(1) = 0;
for k = 2:nPointsTongSurfGeneric
    ratiosRelPosGeneric(k) = sum(lenSegTongSurfGen(1:k-1)) / lenTotTongSurfGen;
end

ratiosRelPosMRI = nan(1, nPointsTongSurfMRISubSampled);
ratiosRelPosMRI(1) = 0;
for i = 2:nPointsTongSurfMRISubSampled
    % Ratio for the other points on the contour
    ratiosRelPosMRI(i) = sum(lenSegTongSurfMRIOrig(1:i-1)) / lenTotTongSurfMRI;
end


% constructing the adapted tongue surface
% the matching process starts by aligning the first point of the adapted
% model (on the hyoid bone) with the first point of the tongue contour of
% the target speaker, and by aligning the tongue tip point of the adapted
% model with the last point of the tongue contour of the target speaker.
tongSurfAdapted(1:2, 1) = tongSurfMRI(1:2, 1);

% to match the upper contour of the adapted model with the tongue contour of
% the target subject each node n of the generic tongue surface is projected onto
% the point nREF of the tongue contour of the target speaker, for which the
% ratio prop_elem_ref gives the best approximation of the ratio
% prop_elem_mod calculated for generic node n.
jlast = 1;
for nbPoint = 2:nPointsTongSurfGeneric-1
    j = jlast;
    while (j < nPointsTongSurfMRISubSampled)
        j = j + 1;
        if ratiosRelPosMRI(j-1) < ratiosRelPosGeneric(nbPoint) && ...
                ratiosRelPosMRI(j) >= ratiosRelPosGeneric(nbPoint)
            jlast = j;
            tongSurfAdapted(1:2, nbPoint) = tongSurfMRI(1:2, j);
        end
    end
end

tongSurfAdapted(1:2, nPointsTongSurfGeneric) = ...
    tongSurfMRI(1:2, nPointsTongSurfMRISubSampled);

end

