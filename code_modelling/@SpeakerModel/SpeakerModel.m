classdef SpeakerModel
    % hold data representing a FEM speaker model
    
    properties
        
        landmarks = [];
        
        structures = [];
        
        tongGrid = PositionFrame();
        
        muscleCollection = MuscleCollection();
        
  
        
    end
    
    methods
        
        function obj = SpeakerModel(struc)

            obj.landmarks.styloidProcess = struc.landmarks.styloidProcess;
            obj.landmarks.condyle = struc.landmarks.condyle;
            obj.landmarks.origin = struc.landmarks.origin;
            obj.landmarks.hyoA = struc.landmarks.hyo1;
            obj.landmarks.hyoB = struc.landmarks.hyo2;
            obj.landmarks.hyoC = struc.landmarks.hyo3;
            obj.landmarks.ANS = struc.landmarks.ANS;
            obj.landmarks.PNS = struc.landmarks.PNS;
            obj.landmarks.tongInsL = struc.landmarks.tongInsL;
            obj.landmarks.tongInsH = struc.landmarks.tongInsH;
            
            obj.structures = struc.structures;
            
            obj.tongGrid = PositionFrame(0, struc.tongGrid.x, struc.tongGrid.y);
            
            obj.muscleCollection = MuscleCollection({'GGP', 'GGA', 'HYO', 'STY', 'VER', 'IL', 'SL'}, ...
                obj.tongGrid, obj.landmarks);
            
        end
        
        [] = initPlotFigure(myModel, false);

        [] = plotStructures(obj, col);
        [] = plotLandmarks(obj, col);
        [] = plotSingleLandmark(obj, nameOfLandmark, col);
        [] = plotTongueMesh(obj, col);
        
        obj = setCondylePoint(obj, xPos, yPos)
        
        muscle = getSingleMuscle(obj, muscleName);
        
        matsOut = exportModelObsolete(obj)
        
    end
    
    
end

