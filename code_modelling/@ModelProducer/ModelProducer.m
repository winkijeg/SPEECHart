classdef ModelProducer
    % produce a FEM-model based on mri data of a specific speaker
    
    
    properties
        
        
        modelGeneric
        
        landmarks
        contours
        gridZoning

        tMatGeom
        tformImg

        contoursTransformed
        landmarksTransformed
        anatomicalStructures
        
        
    end
    
    properties (Constant)
        
        nFibers = 17; % according to rows in the tongue mesh
        nSamplePointsPerFiber = 13; % colums in the tongue mesh
    
    end
    
    methods
        
        function obj = ModelProducer(modelData)
            
            matModelGeneric = load('ypm_model.mat');
            obj.modelGeneric = SpeakerModel(matModelGeneric);
            
            obj.landmarks.styloidProcess = modelData.styloidProcess;
            obj.landmarks.condyle = ...
                [modelData.styloidProcess(1); modelData.styloidProcess(2)+8];
            obj.landmarks.tongInsL = modelData.tongInsL;
            obj.landmarks.tongInsH = modelData.tongInsH;
            obj.landmarks.ANS = modelData.ANS;
            obj.landmarks.PNS = modelData.PNS;
            obj.landmarks.origin = modelData.origin;
            
            obj.contours.innerPt = modelData.innerPt;
            obj.contours.outerPt = modelData.outerPt;
            
            obj.gridZoning.tongue = modelData.idxTongue;
            obj.gridZoning.pharynx = modelData.idxPharynx;
            obj.gridZoning.velum = modelData.idxVelum;
            obj.gridZoning.palate = modelData.idxPalate;
        
            % calculate initial rotation of mri data
            [obj.tMatGeom, obj.tformImg] = calcTransformationImgToModel(obj);
            
            % rotate mri data of specific speaker
            [lmTrans, contsTrans] = transformSpeakerData(obj);
            obj.landmarksTransformed = lmTrans;
            obj.contoursTransformed = contsTrans;
            
            % extract anatomical structures
            obj.anatomicalStructures = convertContoursIntoStructures(obj);
            
            
        end

        model = matchModel( myModelProducer );

    end
    
    methods (Access = private)
        
        [tMatGeom, tformImg] = calcTransformationImgToModel(obj);
        [landmarksTrans, contoursTrans] = transformSpeakerData(obj);
        anatomicalStructures = convertContoursIntoStructures(obj);
        [upperIncisorPalate, ptAttachLip] = matchUpperIncisor(obj, palateMRI, distRatioTeethInsertionPoints);
        upperLip = matchUpperLip(obj, ptAttachIncisor, distRatioTeethInsertionPoints);
        [lowerIncisor, scaleFactor] = matchlowerIncisor(obj, ptAttachIncisor);
        
    end
        
end
