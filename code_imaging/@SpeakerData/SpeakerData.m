classdef SpeakerData
    % store landmarks / contours determined from mid-sagittal MRI image
    %   two contours and two kind of anatomical landmarks are necessary for
    %   the design of the speaker-specific vocal tract models.
    
    properties
        
        speakerName@char
        
        % necessary for model design
        xyStyloidProcess = [NaN; NaN];
        xyTongInsL = [NaN; NaN];
        xyTongInsH = [NaN; NaN];
        xyANS = [NaN; NaN];
        xyPNS = [NaN; NaN];
        
        % necessary for shape measures
        xyVallSin = [NaN; NaN];
        xyAlvRidge = [NaN; NaN];
        xyPharH = [NaN; NaN];
        xyPharL = [NaN; NaN];
        
        % necessary for semi-polar grid
        xyPalate = [NaN; NaN];
        xyLx = [NaN; NaN];
        xyLipU = [NaN; NaN];
        xyLipL = [NaN; NaN];
        %xyPharL = [NaN; NaN];
        %xyPharH = [NaN; NaN];
        %xyAlvRidge = [NaN; NaN];
        %xyANS = [NaN; NaN];
        %xyPNS = [NaN; NaN];
        
        % necessary for split up the contours into anatomical regions
        xyTongTip = [NaN; NaN];
        xyVelum = [NaN; NaN];
        
        % raw contours from manual editor input
        xyInnerTrace_raw = [NaN; NaN] 
        xyOuterTrace_raw = [NaN; NaN]
        
        % postprocessed contours sampled on grid
        xyInnerTrace_sampl = [NaN; NaN]
        xyOuterTrace_sampl = [NaN; NaN]
      
    end
    
    properties (Dependent)
    
        % landmarks for shape measures
        landmarksDerived = struct(...
            'xyPharH_d', [], ...
            'xyPharL_d', [])
        
        circleApproxTongue = struct('xyMidPoint',[],'radius', []) 
        
        grid@SemiPolarGrid
        
        % indices after splitting up contours
        idxTongue
        idxPharynx
        idxVelum
        idxPalate
        
    end
    
    
    methods
        
        function obj = SpeakerData(matSpeakerData)
            % creates object from a full specification determined elsewhere

            if ~isempty(matSpeakerData)
                
                obj.speakerName = matSpeakerData.speakerName;
            
                obj.xyStyloidProcess = matSpeakerData.landmarks.StyloidProcess;
                obj.xyANS = matSpeakerData.landmarks.ANS;
                obj.xyPNS = matSpeakerData.landmarks.PNS;
                obj.xyTongInsL = matSpeakerData.landmarks.TongInsL;
                obj.xyTongInsH = matSpeakerData.landmarks.TongInsH;

                obj.xyVallSin = matSpeakerData.landmarks.VallSin;
                obj.xyAlvRidge = matSpeakerData.landmarks.AlvRidge;
                obj.xyPharH = matSpeakerData.landmarks.PharH;
                obj.xyPharL = matSpeakerData.landmarks.PharL;

                obj.xyPalate = matSpeakerData.landmarks.Palate;
                obj.xyLx = matSpeakerData.landmarks.Lx;
                obj.xyLipU = matSpeakerData.landmarks.LipU;
                obj.xyLipL = matSpeakerData.landmarks.LipL;
                obj.xyTongTip = matSpeakerData.landmarks.TongTip;
                obj.xyVelum = matSpeakerData.landmarks.Velum;

                if isfield(matSpeakerData, 'contours_raw')
                    obj.xyInnerTrace_raw = matSpeakerData.contours_raw.innerPt;
                    obj.xyOuterTrace_raw = matSpeakerData.contours_raw.outerPt;
                else
                    obj.xyInnerTrace_raw = [NaN; NaN];
                    obj.xyOuterTrace_raw = [NaN; NaN];
                end
                
                if isfield(matSpeakerData, 'contours_sampl')
                    obj.xyInnerTrace_sampl = matSpeakerData.contours_sampl.innerPt;
                    obj.xyOuterTrace_sampl = matSpeakerData.contours_sampl.outerPt;
                else
                    obj.xyInnerTrace_sampl = [NaN; NaN];
                    obj.xyOuterTrace_sampl = [NaN; NaN];
                end

            end

        end

        matModelData = getDataForModelCreation(obj)
        h_axes = initPlotFigure(obj, flagImage)
        [] = plot_grid(obj, col, grdLines, h_axes)
        h = plot_landmarks(obj, landmarks, col, h_axes, funcHandle)
        [] = plot_landmarks_derived(obj, col, h_axes)
        h = plot_contour(obj, contType, contName, col, h_axes, funcHandle)
        [] = plot_contour_sampled(obj, col, h_axes)
        [] = plot_contours_modelParts(obj, col, lineWidth, h_axes)
        
        hasValues = hasRawContour(obj, contName)
        hasValues = hasSampledContour(obj, contName)
        hasValues = hasAllLandmarksContours(obj)
        
        [] = export_to_XML(obj, fileName)
        [] = save_to_XML(obj, fileName)
        
        grid_pt_complete = hasGridPoints(obj)
        
        outStrings = get_emptyLandmarkNames(obj)
        outStrings = get_emptyTraceNames(obj)
        xyOut = sample_contour_on_grid(obj, contName)
        
        function pts = get.landmarksDerived(obj)
            
            if ~(isempty(obj.xyANS) || isempty(obj.xyAlvRidge) || isempty(obj.xyPNS))
                
                % ptPharHTmp_d (temporary) is the 4th point of the parallelogramm
                % ANS-AlvRidge-h3-PNS
                xyPharHTmp_d = -obj.xyANS + obj.xyAlvRidge + obj.xyPNS;
                % ptPharH_d is the intersection point between two lines: (1) back
                % pharyngeal wall and (2) the line passing p1 and is parralel to ANS-PNS
                [~, pts.xyPharH_d(:, 1)] = lines_exp_int_2d(...
                    obj.xyAlvRidge', xyPharHTmp_d', obj.xyPharH', obj.xyPharL');

                % ptPharLTmp_d (temporary) is the 4th point of the parallelogram
                % ANS-Hyo-h4-PNS
                xyPharLTmp_d = -obj.xyANS + obj.xyVallSin + obj.xyPNS;
                % ptPharL_d is the intersection point between two lines: (1) back
                % pharyngeal wall and (2) the line passing Hyo and is parralel to ANS-PNS
                [~, pts.xyPharL_d(:, 1)] = lines_exp_int_2d(...
                    obj.xyVallSin', xyPharLTmp_d', obj.xyPharH', obj.xyPharL');

            else
                pts.xyPharH_d = [];
                pts.xyPharL_d = [];
            end
            
        end
        
        function circleApproxTongue = get.circleApproxTongue(obj)
            
            if ~(isempty(obj.xyAlvRidge) || isempty(obj.xyPalate) || isempty(obj.landmarksDerived.xyPharH_d))
                % calculate midpointCircle, the center of a circle intersecting the
                % landmarks p_AlvRidge, p_Palate, p_PharH_d
              
                pointsTmp = [obj.xyAlvRidge obj.xyPalate obj.landmarksDerived.xyPharH_d];
                [myRadius, xyCircleMidpoint(:, 1)] = triangle_circumcircle_2d(pointsTmp);
                circleApproxTongue.xyMidPoint = xyCircleMidpoint;
                circleApproxTongue.radius = myRadius;
            else
                circleApproxTongue.xyMidPoint = [];
                circleApproxTongue.radius = [];
            end
            
        end
         
        function grd = get.grid(obj)
            % creates the semipolar grid
            myStruc.xyAlvRidge = obj.xyAlvRidge;
            myStruc.xyPalate = obj.xyPalate;
            myStruc.xyPharH = obj.xyPharH;
            myStruc.xyPharL = obj.xyPharL;
            myStruc.xyLx = obj.xyLx;
            myStruc.xyLipU = obj.xyLipU;
            myStruc.xyLipL = obj.xyLipL;
            myStruc.xyCircleMidpoint = obj.circleApproxTongue.xyMidPoint;
            
            myGrid = SemiPolarGrid();
            grd = myGrid.calculateGrid(myStruc);
        end

        function idx = get.idxTongue(obj)
            % determine indices for tongue contour
            % split inner contour into anatomical motivated parts.
            % The tongue surface is represented by the contour 
            % between two landmarks (VallSin - TongTip).

            distGrdLineTargetLandmarkStart = ones(1, obj.grid.nGridlines) * NaN;
            distGrdLineTargetLandmarkEnd = ones(1, obj.grid.nGridlines) * NaN;
            for k = 1:obj.grid.nGridlines
                ptGrdInner = obj.grid.innerPt(1:2, k)';
                ptGrdOuter = obj.grid.outerPt(1:2, k)';
                distGrdLineTargetLandmarkStart(k) = segment_point_dist_2d(...
                    ptGrdInner, ptGrdOuter, obj.xyVallSin');
                distGrdLineTargetLandmarkEnd(k) = segment_point_dist_2d(...
                    ptGrdInner, ptGrdOuter, obj.xyTongTip');
            end

            [~, idx(1, 1)] = min(distGrdLineTargetLandmarkStart);
            [~, idx(1, 2)] = min(distGrdLineTargetLandmarkEnd);
        end

        function idx = get.idxPharynx(obj)
            % determine indices for Pharynx contour
            % split outer contour into anatomical motivated parts.
            % The back pharyngeal wall is represented by the contour 
            % between between two landmarks (PharL - PharH).

            distGrdLineTargetLandmarkStart = ones(1, obj.grid.nGridlines) * NaN;
            distGrdLineTargetLandmarkEnd = ones(1, obj.grid.nGridlines) * NaN;

            for k = 1:obj.grid.nGridlines
                ptGrdInner = obj.grid.innerPt(1:2, k)';
                ptGrdOuter = obj.grid.outerPt(1:2, k)';
    
                distGrdLineTargetLandmarkStart(k) = segment_point_dist_2d(...
                    ptGrdInner, ptGrdOuter, obj.xyPharL');
                distGrdLineTargetLandmarkEnd(k) = segment_point_dist_2d(...
                    ptGrdInner, ptGrdOuter, obj.xyPharH');
            end

            [~, idx(1, 1)] = min(distGrdLineTargetLandmarkStart);
            [~, idx(1, 2)] = min(distGrdLineTargetLandmarkEnd);

        end
        
        function idx = get.idxVelum(obj)
            % determine indices for velum contour
            % split outer contour into anatomical motivated parts.
            % The velum is represented by the contour 
            % between between two landmarks (PharH - Velum).

            distGrdLineTargetLandmarkStart = ones(1, obj.grid.nGridlines) * NaN;
            distGrdLineTargetLandmarkEnd = ones(1, obj.grid.nGridlines) * NaN;

            for k = 1:obj.grid.nGridlines
                ptGrdInner = obj.grid.innerPt(1:2, k)';
                ptGrdOuter = obj.grid.outerPt(1:2, k)';

                distGrdLineTargetLandmarkStart(k) = segment_point_dist_2d(...
                    ptGrdInner, ptGrdOuter, obj.xyPharH');
                distGrdLineTargetLandmarkEnd(k) = segment_point_dist_2d(...
                    ptGrdInner, ptGrdOuter, obj.xyVelum');
            end

            [~, idx(1, 1)] = min(distGrdLineTargetLandmarkStart);
            [~, idx(1, 2)] = min(distGrdLineTargetLandmarkEnd);

        end

        function idx = get.idxPalate(obj)
            % determine indices for palate contour
            % split outer contour into anatomical motivated parts.
            % The palate is represented by the contour 
            % between between two landmarks (Velume - Palate).

            distGrdLineTargetLandmarkStart = ones(1, obj.grid.nGridlines) * NaN;
            distGrdLineTargetLandmarkEnd = ones(1, obj.grid.nGridlines) * NaN;

            for k = 1:obj.grid.nGridlines
                ptGrdInner = obj.grid.innerPt(1:2, k)';
                ptGrdOuter = obj.grid.outerPt(1:2, k)';

                distGrdLineTargetLandmarkStart(k) = ...
                    segment_point_dist_2d(ptGrdInner, ptGrdOuter, obj.xyVelum');
                distGrdLineTargetLandmarkEnd(k) = ...
                    segment_point_dist_2d(ptGrdInner, ptGrdOuter, obj.xyAlvRidge');
            end

            [~, idx(1, 1)] = min(distGrdLineTargetLandmarkStart);
            [~, idx(1, 2)] = min(distGrdLineTargetLandmarkEnd);

        end
        
    end
    
end
