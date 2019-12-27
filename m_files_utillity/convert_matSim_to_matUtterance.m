function [ matUtt ] = convert_matSim_to_matUtterance( matSim )
%convert a obsolete simulation mat-file to the new utterance format

    % assign general information -------------------------------------
    matUtt.targetString = matSim.seq;
    matUtt.timeOfFrames = matSim.t;

    % assign model information ---------------------------------------
    matUtt.modelName = matSim.modelName;
    matUtt.modelUUID = matSim.modelUUID;

    % assign information passed by the utterance plan ----------------
    matUtt.durTransition = matSim.TEMPS_ACTIVATION;
    matUtt.durHold = matSim.TEMPS_HOLD;

    % transform MATRICE_LAMBDA from absolute to relative
    matUtt.deltaLambdaGGP = matSim.MATRICE_LAMBDA(1, 2:end) - ...
        matSim.MATRICE_LAMBDA(1, 1);
    matUtt.deltaLambdaGGA = matSim.MATRICE_LAMBDA(2, 2:end) - ...
        matSim.MATRICE_LAMBDA(2, 1);
    matUtt.deltaLambdaHYO = matSim.MATRICE_LAMBDA(3, 2:end) - ...
        matSim.MATRICE_LAMBDA(3, 1);
    matUtt.deltaLambdaSTY = matSim.MATRICE_LAMBDA(4, 2:end) - ...
        matSim.MATRICE_LAMBDA(4, 1);
    matUtt.deltaLambdaVER = matSim.MATRICE_LAMBDA(5, 2:end) - ...
        matSim.MATRICE_LAMBDA(5, 1);
    matUtt.deltaLambdaSL = matSim.MATRICE_LAMBDA(6, 2:end) - ...
        matSim.MATRICE_LAMBDA(6, 1);
    matUtt.deltaLambdaIL = matSim.MATRICE_LAMBDA(7, 2:end) - ...
        matSim.MATRICE_LAMBDA(7, 1);

    matUtt.jawRotation = matSim.jaw_rotation;
    matUtt.lipProtrusion = matSim.lip_protrusion;
    matUtt.lipRotation = matSim.ll_rotation;
    matUtt.hyoid_mov = matSim.hyoid_movment;

    % assign control parameter ---------------------------------------
    matUtt.lambdaGGP = matSim.LAMBDA_TRAJ(:, 1)';
    matUtt.lambdaGGA = matSim.LAMBDA_TRAJ(:, 2)';
    matUtt.lambdaHYO = matSim.LAMBDA_TRAJ(:, 3)';
    matUtt.lambdaSTY = matSim.LAMBDA_TRAJ(:, 4)';
    matUtt.lambdaVER = matSim.LAMBDA_TRAJ(:, 5)';
    matUtt.lambdaSL = matSim.LAMBDA_TRAJ(:, 6)';
    matUtt.lambdaIL = matSim.LAMBDA_TRAJ(:, 7)';

    matUtt.activationGGP = matSim.ACTIV_TRAJ(:, 1)';
    matUtt.activationGGA = matSim.ACTIV_TRAJ(:, 2)';
    matUtt.activationHYO = matSim.ACTIV_TRAJ(:, 3)';
    matUtt.activationSTY = matSim.ACTIV_TRAJ(:, 4)';
    matUtt.activationVER = matSim.ACTIV_TRAJ(:, 5)';
    matUtt.activationSL = matSim.ACTIV_TRAJ(:, 6)';
    matUtt.activationIL = matSim.ACTIV_TRAJ(:, 7)';

    % assign kinematics and dynamics ----------------------------------
    % extract velocity data from U (second half)
    matUtt.velocity = matSim.U(:, 2*221+1:4*221);
    matUtt.acceleration = matSim.ACCL_TRAJ;
    % convert force from original scale to Newton
    matUtt.forceNewton = matSim.FXY_TRAJ * 0.001 * 35;

    % assign position of non-rigid anatomucal structures ---------------

    % reconstruct tongue shape (incl. jaw movement and muscle acivity)

    % determine number of valid frames / invalid first frames are 
    % the consequence of the way synthesis has been programmed ...
    nFramesValid = size(matSim.t, 2);
    nFramesInvalid = size(matSim.ttout, 1) - nFramesValid;

    % CAUTION: in X0_seq/Y0_seq the (first) invalid frames are included
    tongRawJawTransX = matSim.X0_seq(nFramesInvalid+1:end, 1:221);
    tongRawJawTransY = matSim.Y0_seq(nFramesInvalid+1:end, 1:221);

    % extract first half of points (second half contains ...
    % velocity of nodes); U already have values for VALID frames
    positionsTongueTmp = matSim.U(:, 1:2*221);

    posTongDevX = positionsTongueTmp(:, 1:2:2*221);
    posTongDevY = positionsTongueTmp(:, 2:2:2*221);

    posTongX = tongRawJawTransX + posTongDevX;
    posTongY = tongRawJawTransY + posTongDevY;

    matUtt.tongue(:, 1:2:2*221) = posTongX;
    matUtt.tongue(:, 2:2:2*221) = posTongY;

    matUtt.condyle(:, 1:2) = [matSim.U_X_origin(1, nFramesInvalid+1:end)' ...
        matSim.U_Y_origin(1, nFramesInvalid+1:end)'];

    nPtsInc = size(matSim.U_dents_inf, 2)/2;
    matUtt.lowerIncisor(:, 1:2:2*nPtsInc) = ...
        matSim.U_dents_inf(nFramesInvalid+1:end, 1:nPtsInc);
    matUtt.lowerIncisor(:, 2:2:2*nPtsInc) = ...
        matSim.U_dents_inf(nFramesInvalid+1:end, nPtsInc+1:2*nPtsInc);

    nPtsLowerLip = size(matSim.U_lowlip, 2)/2;
    matUtt.lowerLip(:, 1:2:2*nPtsLowerLip) = ...
        matSim.U_lowlip(nFramesInvalid+1:end, 1:nPtsLowerLip);
    matUtt.lowerLip(:, 2:2:2*nPtsLowerLip) = ...
        matSim.U_lowlip(nFramesInvalid+1:end, nPtsLowerLip+1:2*nPtsLowerLip);

    nPtsUpperLip = size(matSim.U_upperlip, 2)/2;
    matUtt.upperLip(:, 1:2:2*nPtsUpperLip) = ...
        matSim.U_upperlip(nFramesInvalid+1:end, 1:nPtsUpperLip);
    matUtt.upperLip(:, 2:2:2*nPtsUpperLip) = ...
        matSim.U_upperlip(nFramesInvalid+1:end, nPtsUpperLip+1:2*nPtsUpperLip);

    nPtsLxAr = size(matSim.U_lar_ar_mri, 2)/2;
    matUtt.larynxArytenoid(:, 1:2:2*nPtsLxAr) = ...
        matSim.U_lar_ar_mri(nFramesInvalid+1:end, 1:nPtsLxAr);
    matUtt.larynxArytenoid(:, 2:2:2*nPtsLxAr) = ...
        matSim.U_lar_ar_mri(nFramesInvalid+1:end, nPtsLxAr+1:2*nPtsLxAr);

    nPtsTongLx = size(matSim.U_tongue_lar_mri, 2)/2;
    matUtt.tongueLarynx(:, 1:2:2*nPtsTongLx) = ...
        matSim.U_tongue_lar_mri(nFramesInvalid+1:end, 1:nPtsTongLx);
    matUtt.tongueLarynx(:, 2:2:2*nPtsTongLx) = ...
        matSim.U_tongue_lar_mri(nFramesInvalid+1:end, nPtsTongLx+1:2*nPtsTongLx);

end

