classdef MuscleCollection
    % represents muscle specifications (7 muscles)
    %   Detailed explanation goes here
    
    properties
        
        nMuscles = NaN;
        namesMuscle = {''}
        muscles = Muscle()
       
    end
    
    methods
        
        function obj = MuscleCollection(muscleNames, tongueMesh, landmarks)

            if nargin  ~= 0
                obj.nMuscles = size(muscleNames, 2);
                obj.namesMuscle = muscleNames;
            
                obj.muscles(obj.nMuscles) = Muscle(); % memory allocation
                for k = 1:obj.nMuscles
                
                    obj.muscles(k) = Muscle(muscleNames{k}, tongueMesh, ...
                        landmarks);
            
                end
                
            end
            
        end
        
        % method declarations .............................................
        
        muscle = getMuscleFromCollection(obj, muscleName);
        
    end
    
end

