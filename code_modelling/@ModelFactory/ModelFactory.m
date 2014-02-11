classdef ModelFactory
    % produce a FEM-model based on real speakers  
    %   Detailed explanation goes here
    
    properties
        
        modelGeneric
        
    end
    
    methods
        
        function obj = ModelFactory()
            
            matModelGeneric = load('ypm_model.mat');
            obj.modelGeneric = SpeakerModel(matModelGeneric);
            
        end
        
        mat = matching2D_ForRefactoring(obj, matRawModelTarget);

    end
        
end

