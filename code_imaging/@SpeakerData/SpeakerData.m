classdef SpeakerData
    % store landmarks / contours determined from mid-sagittal MRI image
    %   two contours and two kind of anatomical landmarks are necessary for
    %   the design of speaker-specific vocal tract models.
    
    properties
        
        speakerName
        
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
        
        xyInnerTrace@double % tongue surface in MRI slice
        xyOuterTrace@double % pharynx and palate trace from MRI slice
      
    end
    
    properties (Dependent)
    
        % landmarks for shape measures
        landmarksDerived = struct(...
            'xyPharH_d', [], ...
            'xyPharL_d', [], ...
            'xyNPW_d', [], ...
            'xyPPDPharL_d', [])
        
        % for semi-polar grid
        xyCircleMidpoint@double
        
        % the semi-polar grid
        grid@SemiPolarGrid
        
        % indices after splitting up contours
        idxTongue
        idxPharynx
        idxVelum
        idxPalate
        
    end
    
    
    methods
        
        function obj = SpeakerData(mySpeakerData)

            obj.speakerName = mySpeakerData.speakerName;
            obj.xyStyloidProcess = mySpeakerData.landmarks.styloidProcess;
            obj.xyANS = mySpeakerData.landmarks.ANS;
            obj.xyPNS = mySpeakerData.landmarks.PNS;
            obj.xyTongInsL = mySpeakerData.landmarks.tongInsL;
            obj.xyTongInsH = mySpeakerData.landmarks.tongInsH;

            obj.xyInnerTrace = mySpeakerData.contours.innerPt;
            obj.xyOuterTrace = mySpeakerData.contours.outerPt;

            obj.xyVallSin = mySpeakerData.landmarks.VallSin;
            obj.xyAlvRidge = mySpeakerData.landmarks.AlvRidge;
            obj.xyPharH = mySpeakerData.landmarks.PharH;
            obj.xyPharL = mySpeakerData.landmarks.PharL;

            obj.xyPalate = mySpeakerData.landmarks.Palate;
            obj.xyLx = mySpeakerData.landmarks.Lx;
            obj.xyLipU = mySpeakerData.landmarks.LipU;
            obj.xyLipL = mySpeakerData.landmarks.LipL;
            obj.xyTongTip = mySpeakerData.landmarks.TongTip;
            obj.xyVelum = mySpeakerData.landmarks.Velum;

        end

        modelData = getDataForModelCreation( obj )
        h_axes = initPlotFigure(obj, flagImage)
        [] = plot_grid ( obj, col, grdLines, h_axes )
        [] = plot_landmarks(obj, landmarks, col, h_axes)
        [] = plot_landmarks_derived( obj, col, h_axes )
        [] = plot_contours(obj, col, h_axes)
        [] = plot_contours_modelParts(obj, col, lineWidth, h_axes)
        
        function pts = get.landmarksDerived(obj)
            
            if ~(isempty(obj.xyANS) || isempty(obj.xyAlvRidge) || isempty(obj.xyPNS))
                
                % ptPharHTmp_d (temporary) is the 4th point of the parallelogramm
                % ANS-AlvRidge-h3-PNS
                xyPharHTmp_d = -obj.xyANS + obj.xyAlvRidge + obj.xyPNS;
                % ptPharH_d is the intersection point between two lines: (1) back
                % pharyngeal wall and (2) the line passing p1 and is parralel to ANS-PNS
                [~, pts.xyPharH_d(:, 1)] = lines_exp_int_2d(...
                    obj.xyAlvRidge', xyPharHTmp_d', obj.xyPharH', obj.xyPharL');

                % ptPharLTmp_d (temporary) is the 4th point of the parallelogramm
                % ANS-Hyo-h4-PNS
                xyPharLTmp_d = -obj.xyANS + obj.xyVallSin + obj.xyPNS;
                % ptPharL_d is the intersection point between two lines: (1) back
                % pharyngeal wall and (2) the line passing Hyo and is parralel to ANS-PNS
                [~, pts.xyPharL_d(:, 1)] = lines_exp_int_2d(...
                    obj.xyVallSin', xyPharLTmp_d', obj.xyPharH', obj.xyPharL');

                % find two derived points (for morpological analysis)
                % (1) intersection point of palatal plane and pharynx wall
                [~, pts.xyNPW_d(:, 1)] = lines_exp_int_2d(...
                    obj.xyANS', obj.xyPNS', pts.xyPharL_d', pts.xyPharH_d');
                % (2) shortest distance from pt_PharL_d to palatal plane
                pts.xyPPDPharL_d(:, 1) = line_exp_perp_2d(...
                    obj.xyANS', obj.xyPNS', pts.xyPharL_d');
            else
                
                pts.xyPharH_d = [];
                pts.xyPharL_d = [];
                pts.xyNPW_d = [];
                pts.xyPPDPharL_d = [];
                
            end
            
        end
        
        function xyCircleMidpoint = get.xyCircleMidpoint(obj)
            
            if ~(isempty(obj.xyAlvRidge) || isempty(obj.xyPalate) || isempty(obj.landmarksDerived.xyPharH_d))
                % calculate midpointCircle, the center of a circle intersecting the
                % landmarks p_AlvRidge, p_Palate, p_PharH_d
                pointsTmp = [obj.xyAlvRidge obj.xyPalate obj.landmarksDerived.xyPharH_d];
                [~, xyCircleMidpoint(:, 1)] = triangle_circumcircle_2d(...
                    pointsTmp);
            else
                xyCircleMidpoint = [];
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
            myStruc.xyCircleMidpoint = obj.xyCircleMidpoint;
            
            myGrid = SemiPolarGrid();
            grd = myGrid.calculateGrid(myStruc);
        end

        function idx = get.idxTongue(obj)
            % determine indices for tongue contour
            % split inner contour into anatomical motivated parts.
            % The tongue surface is represented by the contour 
            % between between two landmarks (VallSin - TongTip).

            % memory allocation
            distGrdLineTargetLandmarkStart = ones(1, ...
                obj.grid.nGridlines) * NaN;
            distGrdLineTargetLandmarkEnd = ones(1, ...
                obj.grid.nGridlines) * NaN;

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

            % memory allocation
            distGrdLineTargetLandmarkStart = ones(1, ...
                obj.grid.nGridlines) * NaN;
            distGrdLineTargetLandmarkEnd = ones(1, ...
                obj.grid.nGridlines) * NaN;

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

            % memory allocation
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

            % memory allocation
            distGrdLineTargetLandmarkStart = ones(1, ...
                obj.grid.nGridlines) * NaN;
            distGrdLineTargetLandmarkEnd = ones(1, ...
                obj.grid.nGridlines) * NaN;

            for k = 1:obj.grid.nGridlines

                ptGrdInner = obj.grid.innerPt(1:2, k)';
                ptGrdOuter = obj.grid.outerPt(1:2, k)';

                distGrdLineTargetLandmarkStart(k) = segment_point_dist_2d(...
                    ptGrdInner, ptGrdOuter, obj.xyVelum');
                distGrdLineTargetLandmarkEnd(k) = segment_point_dist_2d(...
                    ptGrdInner, ptGrdOuter, obj.xyAlvRidge');
            end

            [~, idx(1, 1)] = min(distGrdLineTargetLandmarkStart);
            [~, idx(1, 2)] = min(distGrdLineTargetLandmarkEnd);

        end
        
    end
    
end
