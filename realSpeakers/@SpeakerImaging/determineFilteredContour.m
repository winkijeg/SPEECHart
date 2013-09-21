function filteredContours = determineFilteredContour(obj)
    % smoothes contour for constriction location measurement in MRI slices
    % 
    % the contour is smoothed in parts based on physiological landmarks. All
    % resulting points of the contour lie on the semipolar grid! 

    structureListing = {'tongue', 'pharynx', 'velum', 'palate'};
    pointSelection = {'innerPt', 'outerPt', 'outerPt', 'outerPt'};
    splineOrderListing = {'4', '4', '4', '4'}; % k = 4 == cubic spline interp.
    % (not 3 which is used whith standard matlab)
    
    contours = obj.contours;
    gridZoning = obj.gridZoning;
    grd = obj.semipolarGrid;
    
    filteredContours = contours;
    
    for k = 1:size(structureListing, 2)

        splineOrder = str2double(splineOrderListing{k});

        % determine point indices of the part of contour to be smoothed
        contourBoundaries = gridZoning.(structureListing{k});

        % extract part of contour for smoothing
        ptsSelected = contours.(pointSelection{k})(1:2, ...
            contourBoundaries(1)+1:contourBoundaries(2));
        numberOfPointsTmp = size(ptsSelected, 2); % i.e. approx. 28 for tongue

        knotsCont = linspace(0, 1, numberOfPointsTmp-splineOrder+2);
		evaluationPoints = linspace(0, 1, 4*numberOfPointsTmp);
        
        ptsSelectedSmoothed = deboor_tuned(knotsCont, ptsSelected', ...
            evaluationPoints, splineOrder)';
        
        % get the points back to the grid ---------------------------------
        indGrdLines = contourBoundaries(1)+2:contourBoundaries(2)-1;
        nGrdLines = length(indGrdLines);
        
        for j = 1:nGrdLines
                        
            nbGrdLine = indGrdLines(j);
            % search the intersect. point of the j-th grdline with contour
            p1 = grd.innerPt(1:2, nbGrdLine);
            p2 = grd.outerPt(1:2, nbGrdLine);

            stillNoIntersection = true;
            cnt = 1;
            while stillNoIntersection
                
                q1 = ptsSelectedSmoothed(1:2, cnt);
                q2 = ptsSelectedSmoothed(1:2, cnt+1);

                [flag, r] = segments_int_2d(p1', p2', q1', q2');

                if flag
                    stillNoIntersection = false;
                    filteredContours.(pointSelection{k})(1:2, nbGrdLine) = r;
                end
                
                cnt = cnt + 1;
            end
            
        end
    end

end
