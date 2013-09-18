classdef SpeakerImaging
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        princInvestigator = '';
        name = '';
        phoneme = '';
        scanOrientation = '';
        
        landmarks = [];
        landmarksDerivedMorpho = [];
        landmarksDerivedGrid = [];
        
        measuresMorphology = [];
        
        semipolarGrid = [];
        contours = [];
        
        sliceInfo = '';
        xdataSlice = [];
        ydataSlice = [];
        sliceData = [];
        sliceSegmentationData = [];
    end
    
    methods
        
        function obj = SpeakerImaging(mat)
            
            obj.princInvestigator = mat.princInvestigator;
            obj.name = mat.speakerName;
            obj.phoneme = mat.phonLab;
            obj.scanOrientation = mat.scanOrient;
            
            obj.landmarks = mat.ptPhysio;
            obj.landmarksDerivedMorpho = deriveLandmarksMorpho(obj);
            obj.landmarksDerivedGrid = deriveLandmarksGrid(obj);
            
            obj.measuresMorphology = determineMeasuresMorphology(obj);
            
            obj.semipolarGrid = determineSemipolarGrid(obj);
            
            obj.sliceInfo = mat.sliceInfo;
            obj.xdataSlice = [0 obj.sliceInfo.PixelDimensions(2)*obj.sliceInfo.Dimensions(2)];
            obj.ydataSlice = [obj.sliceInfo.PixelDimensions(3)*obj.sliceInfo.Dimensions(3) 0];
            obj.sliceData = mat.sliceData;
            obj.sliceSegmentationData = mat.sliceSegmentationData;
            
            obj.contours = determineOutlineFromSegmentation(obj);
            
            
        end
        
        [] = plotMidSagittSlice(obj)
        [] = plotLandmarks(obj, col)
        [] = plotLandmarksDerived(obj, col)
        [] = plotMeasuresMorphology(obj, col)
        [] = plotSemipolarGrid(obj, col, nbsOfGrdLines)
        [] = plotContours(obj, col)
        
        obj = resampleMidSagittSlice(obj, targetPixelWidth, targetPixelHeight)
        obj = normalizeMidSagittSlice(obj)
                
    end
    
    methods (Access = private)
           
        ptPhysioDerived = deriveLandmarksMorpho(obj);
        ptPhysioDerived = deriveLandmarksGrid(obj);
        measuresMorphology = determineMeasuresMorphology(obj);
        grid = determineSemipolarGrid(obj);
        contours = determineOutlineFromSegmentation(obj);

    end

    
end
