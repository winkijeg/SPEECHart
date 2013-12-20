classdef SpeakerModel
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        landmarks = [];
        
        structures = [];
        
        tongGrid = PositionFrame();
        
        muscleCollection = MuscleCollection();
        
  
        
    end
    
    methods
        
        function obj = SpeakerModel(mat)

            obj.landmarks.styloidProcess = mat.landmarks.styloidProcess;
            obj.landmarks.condyle = mat.landmarks.condyle;
            obj.landmarks.origin = mat.landmarks.origin;
            obj.landmarks.hyoA = mat.landmarks.hyo1;
            obj.landmarks.hyoB = mat.landmarks.hyo2;
            obj.landmarks.hyoC = mat.landmarks.hyo3;
            
            obj.structures = mat.structures;
            
            obj.tongGrid = PositionFrame(0, mat.tongGrid.x, mat.tongGrid.y);
            
            obj.muscleCollection = MuscleCollection({'GGP', 'GGA', 'HYO', 'STY', 'VER', 'IL', 'SL'}, ...
                obj.tongGrid, obj.landmarks);
            
        end
        
        [] = initPlotFigure(myModel, false);

        [] = plotStructures(obj, col);
        [] = plotLandmarks(obj, col);
        [] = plotTongueMesh(obj, col);
        
        muscle = getSingleMuscle(obj, muscleName);
        
        matsOut = exportModelObsolete(obj)
        
    end
    
    
end

