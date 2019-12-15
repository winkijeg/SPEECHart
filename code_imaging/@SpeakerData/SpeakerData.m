classdef SpeakerData
    % store landmarks / contours determined from mid-sagittal MRI image
    %   two contours and two kind of anatomical landmarks are necessary for
    %   the design of the speaker-specific vocal tract models.
    
    properties
        
        speakerName@char
        
        % necessary for the model design
        xyStyloidProcess@double
        xyTongInsL@double
        xyTongInsH@double
        xyANS@double
        xyPNS@double
        
        % necessary for shape measures --------------------
        xyVallSin@double
        xyAlvRidge@double
        xyPharH@double
        xyPharL@double
        
        % necessary for semi-polar grid
        xyPalate@double
        xyLx@double
        xyLipU@double
        xyLipL@double
        
        % necessary for split up the contours into anatomical regions
        xyTongTip@double
        xyVelum@double
        
        xyInnerTrace = [NaN; NaN] % tongue surface in MRI slice
        xyOuterTrace = [NaN; NaN] % pharynx and palate trace from MRI slice
      
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
                
                obj.xyInnerTrace = matSpeakerData.contours.innerPt;
                obj.xyOuterTrace = matSpeakerData.contours.outerPt;

            end

        end

        matModelData = getDataForModelCreation(obj)
        h_axes = initPlotFigure(obj, flagImage)
        [] = plot_grid(obj, col, grdLines, h_axes)
        h = plot_landmarks(obj, landmarks, col, h_axes, funcHandle)
        [] = plot_landmarks_derived(obj, col, h_axes)
        h = plot_contour(obj, contName, col, h_axes, funcHandle)
        [] = plot_contours_modelParts(obj, col, lineWidth, h_axes)
        
        [] = export_to_XML(obj, fileName)
        
        outStrings = get_emptyLandmarkNames(obj)
        outStrings = get_emptyTraceNames(obj)
        xyOut = calculate_finalTrace(obj, xyIn)
        
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
