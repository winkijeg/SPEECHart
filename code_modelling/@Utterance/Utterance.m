classdef Utterance
    % represent data / trajectories over time of an utterance 
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        
        targetLabels@char           % labels of speech-like target
        
        uttPlan@UtterancePlan       % speech sequence specification

        nTargets@uint8              % number of single targets (excluding initial rest position)
        durationTotal@double        % total duration of the utterance [s]

        
        modelName@char              % remember model name
        modelUUID@char              % chars identifying the corresponding VT model 

        structures = struct(...     % non-rigid anatomical structures
            'upperLip', [], ...
            'larynxArytenoid', [], ...
            'tongueLarynx', [], ...
            'lowerIncisor', [], ...
            'lowerLip', [], ...
            'condyle', []);

        tongue@PositionFrame    % tongue position over time
        
        
        controlParams = struct(...  % control parameters
            'lambda', [], ...
            'activation', []);
        
        nFrames@uint8               % number of time frames
        timeOfFrames@double         % line vector of frame timepoints
        
       
    end

    properties (Constant)
        
        nNodes = 221;
        
    end
    
    properties (GetAccess = public)

        % kinetics and dynamics
        velocity@double
        acceleration@double
        forceNewton@double
                
    end
    
    methods
        
        
        function obj = Utterance(matUtt)
        % construct object from simulation mat-file

            % extract general information regarding the utterance
            obj.targetLabels = matUtt.targetString;
            obj.nTargets = uint8(length(matUtt.targetString)-1);
            obj.durationTotal = matUtt.timeOfFrames(1, end);

            % pass by the original utterance plan ------------------------
            obj.uttPlan = UtterancePlan(matUtt.targetString(2:end));
            obj.uttPlan.durTransition = matUtt.durTransition;
            obj.uttPlan.durHold = matUtt.durHold;

            obj.uttPlan.deltaLambdaGGP = matUtt.deltaLambdaGGP;
            obj.uttPlan.deltaLambdaGGA = matUtt.deltaLambdaGGA;
            obj.uttPlan.deltaLambdaHYO = matUtt.deltaLambdaHYO;
            obj.uttPlan.deltaLambdaSTY = matUtt.deltaLambdaSTY;
            obj.uttPlan.deltaLambdaVER = matUtt.deltaLambdaVER;
            obj.uttPlan.deltaLambdaSL = matUtt.deltaLambdaSL;
            obj.uttPlan.deltaLambdaIL = matUtt.deltaLambdaIL;

            obj.uttPlan.jawRotation = matUtt.jawRotation;
            obj.uttPlan.lipProtrusion = matUtt.lipProtrusion;
            obj.uttPlan.lipRotation = matUtt.lipRotation;
            obj.uttPlan.hyoid_mov = matUtt.hyoid_mov;

            % determine information regarding the model ------------------
            obj.modelName = matUtt.modelName;
            obj.modelUUID = matUtt.modelUUID;

            % organize data with respect to frames
            obj.nFrames = uint8(size(matUtt.timeOfFrames, 2));
            obj.timeOfFrames = matUtt.timeOfFrames;

            % memory allocation for creating objects
            obj.tongue(obj.nFrames) = PositionFrame();
            for k = 1:obj.nFrames

                posTongX = matUtt.tongue(k, 1:2:2*221);
                posTongY = matUtt.tongue(k, 2:2:2*221);

                obj.tongue(k) = ...
                    PositionFrame(obj.timeOfFrames(k), posTongX , posTongY);

            end
            
            % assign anatomical structures ---------
            obj.structures.upperLip = matUtt.upperLip;
            obj.structures.lowerLip = matUtt.lowerLip;
            obj.structures.lowerIncisor = matUtt.lowerIncisor;
            obj.structures.larynxArytenoid = matUtt.larynxArytenoid;
            obj.structures.tongueLarynx = matUtt.tongueLarynx;
            obj.structures.condyle = matUtt.condyle;
            
            % assign control parameters ------------
            obj.controlParams.lambda.GGP = matUtt.lambdaGGP;
            obj.controlParams.lambda.GGA = matUtt.lambdaGGA;
            obj.controlParams.lambda.HYO = matUtt.lambdaHYO;
            obj.controlParams.lambda.STY = matUtt.lambdaSTY;
            obj.controlParams.lambda.VER = matUtt.lambdaVER;
            obj.controlParams.lambda.SL = matUtt.lambdaSL;
            obj.controlParams.lambda.IL = matUtt.lambdaIL;
            
            obj.controlParams.activation.GGP = matUtt.activationGGP;
            obj.controlParams.activation.GGA = matUtt.activationGGA;
            obj.controlParams.activation.HYO = matUtt.activationHYO;
            obj.controlParams.activation.STY = matUtt.activationSTY;
            obj.controlParams.activation.VER = matUtt.activationVER;
            obj.controlParams.activation.SL = matUtt.activationSL;
            obj.controlParams.activation.IL = matUtt.activationIL;

            % assign kinetics / dynamics
            obj.velocity = matUtt.velocity;
            obj.acceleration = matUtt.acceleration;
            obj.forceNewton = matUtt.forceNewton;
            
            
        end
        
        function nbFrame = getFrameNumberFromTime(obj, timePoint)
        % returns the frame number at a given time instant
           
            if timePoint > obj.durationTotal
                error('time instant greater than total duration of utterance ...')
            else
                [~, nbFrame] = min(abs(obj.timeOfFrames - ...
                    timePoint*ones(1, obj.nFrames) ));
            end
            
        end

        h = plotSingleStructure(obj, structName, targetFrame, colorStr, h_axes)
        [] = simulateTongueMovement( obj, pauseSeconds, colStr, model, h_axes )
        [] = writeUttToMPEG4(obj, model, fname, h_axes)
        [] = exportToMAT( obj, fileName )
        
    end
    
end

