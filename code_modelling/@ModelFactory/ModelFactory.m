classdef ModelFactory
    % produce a FEM-model based on real speakers  
    %   Detailed explanation goes here
    
    properties
        
        modelGeneric
        
        matSource
        
    end
    
    methods
        
        function obj = ModelFactory(matFileName)
            
            % load target model data (mat-file of ypm-model)
            mat = load(matFileName);
            
            obj.modelGeneric = SpeakerModel(mat);
            
        end
    
        
        
        obj = adoptSpeakerImagingToGeneric(obj, spkImaging);
        mat = matching2D_ForRefactoring(obj, spkName);

    end
        
end

