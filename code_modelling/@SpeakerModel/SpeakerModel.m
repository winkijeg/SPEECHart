classdef SpeakerModel
    % hold data representing a FEM speaker model
    
    properties
        
        modelName@char
        modelUUID@char
        
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
            'upperLip', [], ...             % non-rigid
            'upperIncisorPalate', [], ...   % rigid
            'velum', [], ...                % rigid
            'backPharyngealWall', [], ...   % rigid
            'larynxArytenoid', [], ...      % non-rigid
            'tongueLarynx', [], ...         % non-rigid
            'lowerIncisor', [], ...         % non-rigid
            'lowerLip', [])                 % non-rigid
        
        tongue@PositionFrame
        
        muscles@MuscleCollection
        
    end
    
    properties (Access = private)
        
        nMeshFibers                 % number of ROWS in the tongue mesh / MM=17
        nSamplePointsPerMeshFiber   % numbner of COLUMNS in the tongue mesh / NN=13
        
    end
    
    
    properties (Constant)
        
        nu = 0.49;                  % Poisson's ratio
        E = 0.35;                   % Young's modulus: stiffness (E = 0.7 in Yohan's theses)
        masse_totale = 0.15 / 35;   % 150 grams per 35 mm width
        
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
            
            obj.nMeshFibers = struc.nMeshFibers;
            obj.nSamplePointsPerMeshFiber = struc.nSamplePointsPerMeshFiber;

            
            obj.tongue = PositionFrame(nan, ...
                struc.tongue.xVal, struc.tongue.yVal);
            
            obj.muscles = MuscleCollection({'GGP', 'GGA', 'HYO', ...
                'STY', 'VER', 'SL', 'IL'}, obj.tongue, obj.landmarks);
            
        end
        
        [] = exportToXML(mySpeakerModel, fileName);
        h = initPlotFigure(obj, imageFlag);
        h = plot_tongueSurface(obj, col, h_axes);
        h = plot_tongueMesh(obj, col, h_axes);
        h = plot_muscles( obj, names, col, h_axes);
        [] = plot_landmarks(obj,landmarks, col, h_axes);
        [] = plot_contours(obj, names, col, h_axes);
        [] = plot_fixed_contours(obj, col, h_axes);

        obj = setCondylePoint(obj, xPos, yPos)

    end
    
    
end

