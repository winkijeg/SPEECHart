classdef MuscleCollection
    % represents muscle specifications (7 muscles)
    
    properties
        
        nMuscles@uint8
        
        namesMuscle@cell
        
        muscles@Muscle
       
    end
    
    methods
        
        function obj = MuscleCollection(muscleNames, tongueGrid, landmarks)

            if nargin  ~= 0
                obj.nMuscles = uint8(size(muscleNames, 2));
                obj.namesMuscle = muscleNames;
            
                obj.muscles(obj.nMuscles) = Muscle(); % memory allocation
                for k = 1:obj.nMuscles
                
                    obj.muscles(k) = Muscle(muscleNames{k}, tongueGrid, ...
                        landmarks);
            
                end
                
            end
            
        end
        
        % method declarations .............................................
        
        muscle = getMuscleFromCollection(obj, muscleName);
        
    end
    
end

