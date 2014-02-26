function [X_repos_new, Y_repos_new] = matchInnerTongueMesh(X_repos, Y_repos, X_repos_new, Y_repos_new)
% adapt inner mesh with regard to the generic tongue mesh

nFibers = 17;
nSamplePointsPerFiber = 13;

% Computation of the internal nodes of the adapted tongue model
for nbFiber = 1:nFibers
    
    ptFiberOriginGEN = [X_repos(nbFiber, 1); Y_repos(nbFiber, 1)];
    ptFiberEndGEN = [X_repos(nbFiber, nSamplePointsPerFiber); ...
        Y_repos(nbFiber, nSamplePointsPerFiber)];
    ptFiberOriginMRI = [X_repos_new(nbFiber, 1); Y_repos_new(nbFiber, 1)];
    ptFiberEndMRI = [X_repos_new(nbFiber, nSamplePointsPerFiber); ...
        Y_repos_new(nbFiber, nSamplePointsPerFiber)];
    
    scaleFactorFiber = points_dist_nd(2, ptFiberEndMRI', ptFiberOriginMRI') / ...
        points_dist_nd(2, ptFiberEndGEN', ptFiberOriginGEN');
    scaleVector = [0 scaleFactorFiber scaleFactorFiber];
    
    % prepare data for transformation
    ptsFiberGEN = [X_repos(nbFiber, 1:nSamplePointsPerFiber); ...
        Y_repos(nbFiber, 1:nSamplePointsPerFiber)]; 
    ptsFiberGEN3D = [zeros(1, nSamplePointsPerFiber); ptsFiberGEN];
    
    translationVector = [0; ptFiberOriginMRI - ptFiberOriginGEN]';
    
    t1 = tmat_init();
    t2 = tmat_trans(t1, translationVector);

    ptFiberMRITmpTrans = tmat_mxp2(t2, nSamplePointsPerFiber, ptsFiberGEN3D);
    ptFiberMRITmpTrans2D = ptFiberMRITmpTrans(2:3, :);
    
    % calculate rotation (after temporarely translated generic fiber) 
    ptFiberOriginGENTrans = ptFiberMRITmpTrans2D(1:2, nSamplePointsPerFiber);
    
    angleRot = angle_deg_2d ( ptFiberEndMRI', ptFiberOriginMRI', ptFiberOriginGENTrans' );
    
    t3 = tmat_trans(t2, [0 -ptFiberOriginMRI']);
    t4 = tmat_scale(t3, scaleVector);
    t5 = tmat_rot_axis(t4, angleRot, 'X');
    t6 = tmat_trans(t5, [0 ptFiberOriginMRI']);
    
    ptFiberMRITmpFin = tmat_mxp2(t6, nSamplePointsPerFiber, ptsFiberGEN3D);
    ptFiberMRI2DFin = ptFiberMRITmpFin(2:3, :);
    
    X_repos_new(nbFiber, 1:13) = ptFiberMRI2DFin(1, :); 
    Y_repos_new(nbFiber, 1:13) = ptFiberMRI2DFin(2, :);
    
end

end
