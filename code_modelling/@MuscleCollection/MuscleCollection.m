classdef MuscleCollection
    % represent collection of specifications for each muscle
    
    properties
        
        nMuscles@uint8          % number of muscles, i.e. 7
        names@cell              % CellString of muscle names
        muscleArray@Muscle      % array of the single muscles
       
    end
    
    methods
        
        function obj = MuscleCollection(muscleNames, tongue, landmarks)

            if nargin  ~= 0
                obj.nMuscles = uint8(size(muscleNames, 2));
                obj.names = muscleNames;
            
                obj.muscleArray(obj.nMuscles) = Muscle(); % memory allocation
                for nbMuscle = 1:obj.nMuscles
                
                    obj.muscleArray(nbMuscle) = Muscle(muscleNames{nbMuscle}, ...
                        tongue, landmarks);
            
                end
                
            end
            
        end
        
        muscle = getMuscleFromCollection(obj, muscleName);
        
    end
    
end

