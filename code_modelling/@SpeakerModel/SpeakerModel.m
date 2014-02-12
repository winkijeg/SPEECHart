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
        
        function obj = SpeakerModel(struc)

            obj.landmarks.styloidProcess = struc.landmarks.styloidProcess;
            obj.landmarks.condyle = struc.landmarks.condyle;
            obj.landmarks.origin = struc.landmarks.origin;
            obj.landmarks.hyoA = struc.landmarks.hyo1;
            obj.landmarks.hyoB = struc.landmarks.hyo2;
            obj.landmarks.hyoC = struc.landmarks.hyo3;
            obj.landmarks.ANS = struc.landmarks.ANS;
            obj.landmarks.PNS = struc.landmarks.PNS;
            
            obj.structures = struc.structures;
            
            obj.tongGrid = PositionFrame(0, struc.tongGrid.x, struc.tongGrid.y);
            
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

