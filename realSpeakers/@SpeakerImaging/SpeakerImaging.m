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
        measuresTongueShape = [];
        basicData = [];
        
        semipolarGrid = [];
        gridZoning = [];
        
        contours = [];
        filteredContours = [];
        
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
            obj.gridZoning = zoneGridIntoAnatomicalRegions(obj);
            
            obj.sliceInfo = mat.sliceInfo;
            obj.xdataSlice = [0 obj.sliceInfo.PixelDimensions(2)*obj.sliceInfo.Dimensions(2)];
            obj.ydataSlice = [obj.sliceInfo.PixelDimensions(3)*obj.sliceInfo.Dimensions(3) 0];
            obj.sliceData = mat.sliceData;
            obj.sliceSegmentationData = mat.sliceSegmentationData;
            
            obj.contours = determineOutlineFromSegmentation(obj);
            obj.filteredContours = determineFilteredContour(obj);
            
            [mTS, dTS] = determineMeasuresTongueShape(obj);
            obj.measuresTongueShape = mTS;
            obj.basicData = dTS;

            
        end
        
        [] = plotMidSagittSlice(obj)
        [] = plotLandmarks(obj, col)
        [] = plotLandmarksDerived(obj, col)
        [] = plotMeasureMorphology(obj, featureName, col)
        [] = plotMeasureTongueShape(obj, featureName, col)
        [] = plotSemipolarGrid(obj, col, nbsOfGrdLines)
        [] = plotContours(obj, flagBspline, col)
        
        obj = resampleMidSagittSlice(obj, targetPixelWidth, targetPixelHeight)
        obj = normalizeMidSagittSlice(obj)
                
    end
    
    methods (Access = private)
           
        ptPhysioDerived = deriveLandmarksMorpho(obj);
        ptPhysioDerived = deriveLandmarksGrid(obj);
        measuresMorphology = determineMeasuresMorphology(obj);
        [mTS, dTS] = determineMeasuresTongueShape(obj);
        grid = determineSemipolarGrid(obj);
        gridZoning = zoneGridIntoAnatomicalRegions(obj);
        contours = determineOutlineFromSegmentation(obj);
        filteredContours = determineFilteredContour(obj);

    end

    methods (Static)
        
        [val, basicData] = determineCurvatureInvRadius(ptStart, ptMid, ptEnd)
        [val, basicData] = determineCurvatureQuadCoeff(innerPtPart)
    end
    
end

