classdef ModelProducer
    % produce a FEM-model based on mri-data of a specific speaker
    
    properties
        
        modelGeneric
        
        tformImg
        tMatGeom
        
    end
    
    methods
        
        function obj = ModelProducer()
            
            matModelGeneric = load('ypm_model.mat');
            obj.modelGeneric = SpeakerModel(matModelGeneric);
            
        end
        
        structsAnatomical = convertContoursIntoStructures(obj, strucTransformed, gridZoning)
        
        [tMatGeom, tformImg] = calcTransformationImgToModel(obj, matRawModelTarget);
        strucTransformed = transformSpeakerData(obj, strucOrig, tMat);

        struc = matching2D_ForRefactoring(obj, matRawModelTarget);

    end
        
end
