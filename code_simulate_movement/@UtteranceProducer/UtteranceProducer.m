classdef UtteranceProducer
    %simulates tongue movement based on a model and an utternace plan
    
    properties
        
        model@SpeakerModel
        
    end
    
    methods
        
        function obj = UtteranceProducer( myModel )
            
            obj.model = myModel;
            
        end
        
        strucUtterance = simulateMovement(obj, uttPlan)
        
    end
    
end

