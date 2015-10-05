classdef UtteranceProducer
    %simulates tongue movement based on a VT model and an utterance plan
    
    properties
        
        model@SpeakerModel  % the VT model which moves the articulators
        
    end
    
    methods
        
        function obj = UtteranceProducer( myModel )
            % creates object based on a specific VT model
            
            obj.model = myModel;
            
        end
        
        [matObs, strucUtterance] = simulateMovement(obj, uttPlan, myPlotFlag)
        
    end
    
end

