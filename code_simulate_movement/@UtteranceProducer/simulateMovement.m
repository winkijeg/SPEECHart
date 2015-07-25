function matUtterance = simulateMovement(obj, uttPlan)
%simulates tongue movement with control parameters (muscles/time)

    modelName = obj.model.modelName;
    modelUUID = obj.model.modelUUID;
    
    seq = ['r' uttPlan.target];
    
    landmarks.xyStyloidProcess = obj.model.landmarks.xyStyloidProcess;
    landmarks.xyCondyle = obj.model.landmarks.xyCondyle;
%   landmarks.xyANS = obj.model.landmarks.xyANS;
%   landmarks.xyPNS = obj.model.landmarks.xyPNS;
%   landmarks.xyOrigin = obj.model.landmarks.xyOrigin;
%   landmarks.xyTongInsL = obj.model.landmarks.xyTongInsL;
%   landmarks.xyTongInsH = obj.model.landmarks.xyTongInsH;
    landmarks.xyHyoA = obj.model.landmarks.xyHyoA;
    landmarks.xyHyoB = obj.model.landmarks.xyHyoB;
    landmarks.xyHyoC = obj.model.landmarks.xyHyoC;
    
    structures.larynxArytenoid = obj.model.structures.larynxArytenoid;
    structures.backPharyngealWall = obj.model.structures.backPharyngealWall;
    structures.upperLip = obj.model.structures.upperLip;
    structures.upperIncisorPalate = obj.model.structures.upperIncisorPalate;
    structures.velum = obj.model.structures.velum;
    structures.tongueLarynx = obj.model.structures.tongueLarynx;
    structures.lowerIncisor = obj.model.structures.lowerIncisor;
    structures.lowerLip = obj.model.structures.lowerLip;
    
    tongMesh = obj.model.tongue; % Class PositionFrame
    positionValuesTmp = getPositionOfNodeNumbers(tongMesh, 1:221);
    tongueRest.X0 = reshape(positionValuesTmp(1, :), 13, 17)';
    tongueRest.Y0 = reshape(positionValuesTmp(2, :), 13, 17)';
    
    tongConstVals.E = obj.model.E;
    tongConstVals.nu = obj.model.nu;
    tongConstVals.masse_totale = obj.model.masse_totale;
    tongConstVals.ordre = obj.model.ordre;
    tongConstVals.H = obj.model.H;
    tongConstVals.G = obj.model.G;
    
    
    myMuscleCol = obj.model.muscles;
    
    % delta lambda values; order is GGP GGA HYO STY VER SL IL
    matUtterance = simul_tongue_adapt_jaw(landmarks, structures, ...
        tongueRest, tongConstVals, myMuscleCol, modelUUID, modelName, seq, ...
        uttPlan.deltaLambdaGGP, ...
        uttPlan.deltaLambdaGGA, ...
        uttPlan.deltaLambdaHYO, ...
        uttPlan.deltaLambdaSTY, ...
        uttPlan.deltaLambdaVER, ...
        uttPlan.deltaLambdaSL, ...
        uttPlan.deltaLambdaIL, ...
        uttPlan.durTransition, ...
        uttPlan.durHold, ...
        uttPlan.jawRotation, ...
        uttPlan.lipProtrusion, ...
        uttPlan.lipRotation, ...
        uttPlan.hyoid_mov);
    
end
