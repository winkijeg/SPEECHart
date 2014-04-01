function tongSurfAdapted = matchTongueSurface(tongSurface_Generic, tongSurf_MRI)
% adapt MRI tongue surface with respect to the generic tongue surface

nPtsTongSurf_Generic = size(tongSurface_Generic, 2);
nPtsTongSurf_MRI = size(tongSurf_MRI, 2);

% upsample raw MRI tongue surface
xValsTmp = spline(1:nPtsTongSurf_MRI, tongSurf_MRI(1, :), ...
    1:1/10:nPtsTongSurf_MRI);
yValsTmp = spline(1:nPtsTongSurf_MRI, tongSurf_MRI(2, :), ...
    1:1/10:nPtsTongSurf_MRI);
tongSurface_MRI_upsampled = [xValsTmp; yValsTmp];
nPtsTongSurf_MRI_upsampled = size(tongSurface_MRI_upsampled, 2);

% compute piecewise length of the generic tongue contour
lenSegTongSurfGen = nan(1, nPtsTongSurf_Generic-1);
for k = 1:nPtsTongSurf_Generic-1
    lenSegTongSurfGen(k) = points_dist_nd (2, ...
        tongSurface_Generic(:, k), tongSurface_Generic(:, k+1));
end
lenTotTongSurfGen = sum(lenSegTongSurfGen);

% computation of the piecewise length of the mri tongue contour
lenSegTongSurfMRIOrig = nan(1, nPtsTongSurf_MRI_upsampled-1);
for k = 1:nPtsTongSurf_MRI_upsampled-1
    lenSegTongSurfMRIOrig(k) = points_dist_nd (2, ...
        tongSurface_MRI_upsampled(:, k), tongSurface_MRI_upsampled(:, k+1));
end
lenTotTongSurfMRI = sum(lenSegTongSurfMRIOrig);

% calculate the relative position of the nodes along the generic tongue surface. 
% the reference point is the first point of the
% surface located on the hyoid bone. The relative position of each surface node 
% is characterised by the ratio ratioRelPosGen of its distance to the 
% reference point divided by the total length of the tongue surface.

% for the first point the ratio is obviously 0
ratiosRelPosGeneric = nan(1, nPtsTongSurf_Generic);
ratiosRelPosGeneric(1) = 0;
for k = 2:nPtsTongSurf_Generic
    ratiosRelPosGeneric(k) = sum(lenSegTongSurfGen(1:k-1)) / lenTotTongSurfGen;
end

ratiosRelPosMRI = nan(1, nPtsTongSurf_MRI_upsampled);
ratiosRelPosMRI(1) = 0;
for i = 2:nPtsTongSurf_MRI_upsampled
    % Ratio for the other points on the contour
    ratiosRelPosMRI(i) = sum(lenSegTongSurfMRIOrig(1:i-1)) / lenTotTongSurfMRI;
end


% constructing the adapted tongue surface
% the matching process starts by aligning the first point of the adapted
% model (on the hyoid bone) with the first point of the tongue contour of
% the target speaker, and by aligning the tongue tip point of the adapted
% model with the last point of the tongue contour of the target speaker.
tongSurfAdapted(1:2, 1) = tongSurface_MRI_upsampled(1:2, 1);

% to match the upper contour of the adapted model with the tongue contour of
% the target subject each node n of the generic tongue surface is projected onto
% the point nREF of the tongue contour of the target speaker, for which the
% ratio prop_elem_ref gives the best approximation of the ratio
% prop_elem_mod calculated for generic node n.
jlast = 1;
for nbPoint = 2:nPtsTongSurf_Generic-1
    j = jlast;
    while (j < nPtsTongSurf_MRI_upsampled)
        j = j + 1;
        if ratiosRelPosMRI(j-1) < ratiosRelPosGeneric(nbPoint) && ...
                ratiosRelPosMRI(j) >= ratiosRelPosGeneric(nbPoint)
            jlast = j;
            tongSurfAdapted(1:2, nbPoint) = tongSurface_MRI_upsampled(1:2, j);
        end
    end
end

tongSurfAdapted(1:2, nPtsTongSurf_Generic) = ...
    tongSurface_MRI_upsampled(1:2, nPtsTongSurf_MRI_upsampled);

end

