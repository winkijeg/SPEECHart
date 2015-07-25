classdef MuscleCollection
    % represents muscle specifications (7 muscles)
    
    properties
        
        nMuscles@uint8
        names@cell
        muscleArray@Muscle
       
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
        
        % method declarations .............................................
        
        muscle = getMuscleFromCollection(obj, muscleName);
        
    end
    
end

