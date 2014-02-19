classdef ModelProducer
    % produce a FEM-model based on mri-data of a specific speaker
    
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
    
    methods
        
        function obj = ModelProducer(dataSpkMRI, gridZoning)
            
            matModelGeneric = load('ypm_model.mat');
            obj.modelGeneric = SpeakerModel(matModelGeneric);
            
            obj.landmarks.styloidProcess = dataSpkMRI.styloidProcess;
            obj.landmarks.condyle = dataSpkMRI.condyle;
            obj.landmarks.tongInsL = dataSpkMRI.tongInsL;
            obj.landmarks.tongInsH = dataSpkMRI.tongInsH;
            obj.landmarks.ANS = dataSpkMRI.ANS;
            obj.landmarks.PNS = dataSpkMRI.PNS;
            obj.landmarks.origin = dataSpkMRI.origin;
            
            obj.contours.innerPt = dataSpkMRI.innerPt;
            obj.contours.outerPt = dataSpkMRI.outerPt;
            
            obj.gridZoning = gridZoning;
        
            % calculate initial rotation of mri data
            [obj.tMatGeom, obj.tformImg] = calcTransformationImgToModel(obj);
            
            % rotate mri data of specific speaker
            [lmTrans, contsTrans] = transformSpeakerData(obj);
            obj.landmarksTransformed = lmTrans;
            obj.contoursTransformed = contsTrans;
            
            % extract anatomical structures
            obj.anatomicalStructures = convertContoursIntoStructures(obj);
            
            
        end

        dataModel = matchModel( obj );

    end
    
    methods (Access = private)
        
        [tMatGeom, tformImg] = calcTransformationImgToModel(obj);
        [landmarksTrans, contoursTrans] = transformSpeakerData(obj);
        anatomicalStructures = convertContoursIntoStructures(obj);
        [upperIncisorPalate, ptAttachLip] = matchUpperIncisor(obj, palateMRI, distRatioTeethInsertionPoints);
        upperLip = matchUpperLip(obj, ptAttachIncisor, distRatioTeethInsertionPoints);
        lowerLip = matchLowerLip(obj, ptAttachIncisor, distRatioTeethInsertionPoints);
    end
        
end
