function [] = exportToMAT( obj, fileName )
% write content of the utterance into a XML-file


    matUtterance.targetString = obj.targetLabels;
    matUtterance.timeOfFrames = obj.timeOfFrames;
    matUtterance.modelName = obj.modelName;
    matUtterance.modelUUID = obj.modelUUID;
    
    % format utterance plan ------------------------------
    matUtterance.durTransition = obj.uttPlan.durTransition;
    matUtterance.durHold = obj.uttPlan.durHold;
    
    matUtterance.deltaLambdaGGP = obj.uttPlan.deltaLambdaGGP;
    matUtterance.deltaLambdaGGA = obj.uttPlan.deltaLambdaGGA;
    matUtterance.deltaLambdaHYO = obj.uttPlan.deltaLambdaHYO;
    matUtterance.deltaLambdaSTY = obj.uttPlan.deltaLambdaSTY;
    matUtterance.deltaLambdaVER = obj.uttPlan.deltaLambdaVER;
    matUtterance.deltaLambdaSL = obj.uttPlan.deltaLambdaSL;
    matUtterance.deltaLambdaIL = obj.uttPlan.deltaLambdaIL;
    
    matUtterance.jawRotation = obj.uttPlan.jawRotation;
    matUtterance.lipProtrusion = obj.uttPlan.lipProtrusion;
    matUtterance.lipRotation = obj.uttPlan.lipRotation;
    matUtterance.hyoid_mov = obj.uttPlan.hyoid_mov;
    
    % format control parameters -------------------------
    matUtterance.lambdaGGP = obj.controlParams.lambda.GGP;
    matUtterance.lambdaGGA = obj.controlParams.lambda.GGA;
    matUtterance.lambdaHYO = obj.controlParams.lambda.HYO;
    matUtterance.lambdaSTY = obj.controlParams.lambda.STY;
    matUtterance.lambdaVER = obj.controlParams.lambda.VER;
    matUtterance.lambdaSL = obj.controlParams.lambda.SL;
    matUtterance.lambdaIL = obj.controlParams.lambda.IL;
    
    matUtterance.activationGGP = obj.controlParams.activation.GGP;
    matUtterance.activationGGA = obj.controlParams.activation.GGA;
    matUtterance.activationHYO = obj.controlParams.activation.HYO;
    matUtterance.activationSTY = obj.controlParams.activation.STY;
    matUtterance.activationVER = obj.controlParams.activation.VER;
    matUtterance.activationSL = obj.controlParams.activation.SL;
    matUtterance.activationIL = obj.controlParams.activation.IL;

    % format kinetics and dynamics -----------------------
    matUtterance.velocity = obj.velocity;
    matUtterance.acceleration = obj.acceleration;
    matUtterance.forceNewton = obj.forceNewton;
    
    % format anatomical structures
    matUtterance.tongue = zeros(obj.nFrames, 2*obj.nNodes);
    for nbPosFrame = 1:obj.nFrames
        
        matUtterance.tongue(nbPosFrame, 1:2:2*obj.nNodes) = obj.tongue(nbPosFrame).xValNodes;
        matUtterance.tongue(nbPosFrame, 2:2:2*obj.nNodes) = obj.tongue(nbPosFrame).yValNodes;
        
    end
    
    matUtterance.upperLip = obj.structures.upperLip;
    matUtterance.lowerLip = obj.structures.lowerLip;
    matUtterance.condyle = obj.structures.condyle;
    matUtterance.lowerIncisor = obj.structures.lowerIncisor;
    matUtterance.tongueLarynx = obj.structures.tongueLarynx;
    matUtterance.larynxArytenoid = obj.structures.larynxArytenoid;
    
    save (fileName, '-struct', 'matUtterance')
    
end