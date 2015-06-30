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
      
    end
    
    properties (Dependent)
    
        % landmarks for shape measures
        landmarksDerived = struct(...
            'xyPharH_d', [], ...
            'xyPharL_d', [], ...
            'xyNPW_d', [], ...
            'xyPPDPharL_d', [])
        
        % for semi-polar grid
        xyCircleMidpoint
        
        % the semi-polar grid
        grid
        
        % indices after splitting up contours
        idxTongue
        idxPharynx
        idxVelum
        idxPalate
        
    end
    
    
    methods
        
%         function obj = SpeakerData(struc)
%
%             
%             obj.speakerName = 
%             
%         end

        modelData = getDataForModelCreation( obj )
        [] = disp( obj )
        
        function pts = get.landmarksDerived(obj)
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
            
        end
        
        function xyCircleMidpoint = get.xyCircleMidpoint(obj)
            % calculate midpointCircle, the center of a circle intersecting the
            % landmarks p_AlvRidge, p_Palate, p_PharH_d
            pointsTmp = [obj.xyAlvRidge obj.xyPalate obj.landmarksDerived.xyPharH_d];
            [~, xyCircleMidpoint(:, 1)] = triangle_circumcircle_2d(...
                pointsTmp);
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
            % split inner contour into anatomical motivated parts
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
