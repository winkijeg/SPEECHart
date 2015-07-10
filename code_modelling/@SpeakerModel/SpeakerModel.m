classdef SpeakerModel
    % hold data representing a FEM speaker model
    
    properties
        
        modelName
        modelUUID
        
        landmarks = struct(...
            'xyStyloidProcess', [], ...
            'xyCondyle', [], ...
            'xyOrigin', [], ...
            'xyHyoA', [], ...
            'xyHyoB', [], ...
            'xyHyoC', [], ...
            'xyANS', [], ...
            'xyPNS', [], ...
            'xyTongInsL', [], ...
            'xyTongInsH', [])
        
        structures = struct(...
            'upperLip', [], ...
            'upperIncisorPalate', [], ...
            'velum', [], ...
            'backPharyngealWall', [], ...
            'larynxArytenoid', [], ...
            'tongueLarynx', [], ...
            'lowerIncisor', [], ...
            'lowerLip', [])
        
        tongGrid@PositionFrame
        
        muscleCollection@MuscleCollection
        
    end
    
    properties (Constant)
        
        nu = 0.49;  % Poisson's ratio
        E = 0.35;   % Young's modulus: stiffness (E = 0.7 in Yohan's theses)
        masse_totale = 0.15 / 35;       % <=> 150 grammes sur 40 mm de large
                                        % <=> 150 grams per 40 mm width
                                        % possibly 35 mm??
        
        % Gaussian variables used for squaring A0
        % In this way, calculating the integral is replaced by a sum: SUM(Hi*f(Gi))
        ordre = 2;

        H = [2.0 0 0; ...
            1.0 1.0 0; ...
            0.555556 0.888889 0.555556];

        G = [0.0 0 0; ...
            -0.577350 0.577350 0; ...
            -0.774597 0.0 0.774597];

    end
    
    
    methods
        
        function obj = SpeakerModel(struc)
            
            obj.modelName = struc.modelName;
            obj.modelUUID = struc.modelUUID;

            obj.landmarks = struc.landmarks;
            
            obj.structures = struc.structures;
            
            obj.tongGrid = PositionFrame(nan, ...
                struc.tongGrid.xVal, struc.tongGrid.yVal);
            
            obj.muscleCollection = MuscleCollection({'GGP', 'GGA', 'HYO', ...
                'STY', 'VER', 'IL', 'SL'}, obj.tongGrid, obj.landmarks);
            
        end
        
        h = initPlotFigure(obj, image_flag);

        [] = plotRigidStructures(obj, col);
        [] = plotLandmarks(obj, col);
        [] = plotSingleLandmark(obj, nameOfLandmark, col, repString);
        [] = plotTongueMesh(obj, col);
        
        obj = setCondylePoint(obj, xPos, yPos)
        
        muscle = getSingleMuscle(obj, muscleName);
        
        [] = writeUttToMPEG4(obj, utterance, fname)
        
        [] = exportToXML(mySpeakerModel, fileName);

        
    end
    
    
end

