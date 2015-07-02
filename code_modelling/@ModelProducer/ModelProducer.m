classdef ModelProducer
% construct a VT model based on mri data of a specific speaker
%   The
    
    
    properties
        
        modelName
        
        % 
        landmarks
        contours
        gridZoning

        contoursTransformed
        landmarksTransformed
        anatomicalStructures

    end
    
    properties (Constant)
        
        nFibers = 17; % number of ROWS in the tongue mesh
        nSamplePointsPerFiber = 13; % numbner of COLUMNS in the tongue mesh
    
    end
    
    properties (SetAccess = private)

        modelGeneric

        tMatGeom    % transformation matrix from MRI to model space
        tformImg
        
    
    end
    
    methods
        
        function obj = ModelProducer( modelData )
            
            % read generic model from disk and assign to the object
            matModelGeneric = xml_read('ypm_model_generic.xml');
            obj.modelGeneric = SpeakerModel(matModelGeneric);
            
            % assign specific MRI-data to the object
            obj.modelName = modelData.speakerName;
            
            obj.landmarks.xyStyloidProcess = modelData.xyStyloidProcess;
            obj.landmarks.xyCondyle = ...
                [modelData.xyStyloidProcess(1); ...
                modelData.xyStyloidProcess(2)+8];
            obj.landmarks.xyTongInsL = modelData.xyTongInsL;
            obj.landmarks.xyTongInsH = modelData.xyTongInsH;
            obj.landmarks.xyANS = modelData.xyANS;
            obj.landmarks.xyPNS = modelData.xyPNS;
            obj.landmarks.xyOrigin = modelData.xyOrigin;
            
            obj.contours.innerPt = modelData.innerPt;
            obj.contours.outerPt = modelData.outerPt;
            
            obj.gridZoning.tongue = modelData.idxTongue;
            obj.gridZoning.pharynx = modelData.idxPharynx;
            obj.gridZoning.velum = modelData.idxVelum;
            obj.gridZoning.palate = modelData.idxPalate;
        
            
            % calculate transformation matrix from mri to model space
            [obj.tMatGeom, obj.tformImg] = calcTransformationImgToModel(obj);
            
            % transform landmarks and contours from MRI to model space
            [lmTrans, contsTrans] = transformSpeakerData(obj);
            obj.landmarksTransformed = lmTrans;
            obj.contoursTransformed = contsTrans;
            
            % extract anatomical structures
            obj.anatomicalStructures = convertContoursIntoStructures(obj);
            
            
        end

        model = matchModel( obj );

    end
    
    methods (Access = private)
        
        [tMatGeom, tformImg] = calcTransformationImgToModel(obj);
        [landmarksTrans, contoursTrans] = transformSpeakerData(obj);
        anatomicalStructures = convertContoursIntoStructures(obj);
        [upperIncisorPalate, ptAttachLip] = matchUpperIncisor(obj, palateMRI, distRatioTeethInsertionPoints);
        upperLip = matchUpperLip(obj, ptAttachIncisor, distRatioTeethInsertionPoints);
        [lowerIncisor, scaleFactor] = matchlowerIncisor(obj, ptAttachIncisor);
        
    end
    
    methods (Static)
        
        lowerLip = matchLowerLip(ptAttachIncisor, distRatio)
        
    end
    
        
end
