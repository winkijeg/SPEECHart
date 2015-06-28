classdef SpeakerData
    % store landmarks / contours determined from mid-sagittal MRI image
    %   two contours and two kind of anatomical landmarks are necessary for
    %   the design of speaker-specific vocal tract models.
    
    properties
        
        speakerName = '';
        
        % necessary for the model design
        xyStyloidProcess = [];
        xyTongInsL = [];
        xyTongInsH = [];
        xyANS = [];
        xyPNS = [];
        
        % necessary for shape measures --------------------
        xyVallSin = [];
        xyAlvRidge = [];
        xyPharH = [];
        xyPharL = [];
        
        % necessary for semi-polar grid
        xyPalate = [];
        xyLx = [];
        xyLipU = [];
        xyLipL = [];
        
        % necessary for split up the contours into anatomical regions
        xyTongTip = [];
        xyVelum = [];
        
        xyInnerTrace = []; % tongue surface in MRI slice
        xyOuterTrace = []; % pharynx and palate trace from MRI slice

        % semi-polar grid
        grid = [];
        
        % indices after splitting up contours
        idxTongue = [];
        idxPharynx = [];
        idxVelum = []; % TODO: specific velum should be replaced by standard velum 
        idxPalate = [];
        
    end
    
    properties (Access = private)
    
        % DERIVED landmarks for shape measures and semi-polar grid
        xyPharH_d = [];
        xyPharL_d = [];
        xyNPW_d = [];
        xyPPDPharL_d = [];
        
        % necessary for semi-polar grid
        xyCircleMidpoint = [];

        
    end
    
    methods
        
%         function obj = SpeakerData(struc)
%
%             
%             obj.speakerName = 
%             
%         end

        obj = calcLandmarksMorphology( obj )
        obj = calcLandmarksGrid( obj )
        
        gridData = getDataForGrid( obj )
        modelData = getDataForModelCreation( obj )
        
        [] = disp( obj )
        
        obj = updateIdxTongue( obj )
        obj = updateIdxPharynx( obj )
        obj = updateIdxVelum( obj )
        obj = updateIdxPalate( obj )

    end
    
end
