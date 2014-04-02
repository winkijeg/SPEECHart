function scaleFactor = calculateMatchingScaleFactor(tongInsH_mri, ...
    tongInsL_mri, tongInsH_generic, tongInsL_generic)
% calculate scaling factor necessary for the matching process

dist_mri = points_dist_nd(2, tongInsH_mri, tongInsL_mri);
dist_generic = points_dist_nd(2, tongInsH_generic, tongInsL_generic);

scaleFactor = dist_mri / dist_generic;