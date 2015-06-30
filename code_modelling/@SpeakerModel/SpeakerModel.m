classdef SpeakerModel
    % hold data representing a FEM speaker model
    
    properties
        
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
    
    methods
        
        function obj = SpeakerModel(struc)

            obj.landmarks = struc.landmarks;
            
            obj.structures = struc.structures;
            
            obj.tongGrid = PositionFrame(nan, ...
                struc.tongGrid.xVal, struc.tongGrid.yVal);
            
            obj.muscleCollection = MuscleCollection({'GGP', 'GGA', 'HYO', ...
                'STY', 'VER', 'IL', 'SL'}, obj.tongGrid, obj.landmarks);
            
        end
        
        h = initPlotFigure(obj, image_flag);

        [] = plotStructures(obj, col);
        [] = plotLandmarks(obj, col);
        [] = plotSingleLandmark(obj, nameOfLandmark, col, repString);
        [] = plotTongueMesh(obj, col);
        
        obj = setCondylePoint(obj, xPos, yPos)
        
        muscle = getSingleMuscle(obj, muscleName);
        
        matsOut = exportModelObsolete(obj)
        
        [] = writeUttToMPEG4(obj, utterance, fname)
        
        [] = exportToXML(mySpeakerModel, fileName);

        
    end
    
    
end

