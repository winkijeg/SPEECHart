function filteredContours = determineFilteredContour(obj)
    % smoothes contour for constriction location measurement in MRI slices
    % 
    % the contour is smoothed in parts based on physiological landmarks. All
    % resulting points of the contour lie on the semipolar grid! 

    struct_string = {'tongue', 'pharynx', 'velum', 'palate'};
    specify_string_cont = {'innerPt', 'outerPt', 'outerPt', 'outerPt'};
    % k = 4 == cubic spline interp. (not 3 which is used whith standard matlab)
    spline_order_string = {'4', '4', '4', '4'};

    contours = obj.contours;
    gridZoning = obj.gridZoning;
    grd = obj.semipolarGrid;
    
    filteredContours = contours;
    
    for k = 1:size(struct_string, 2)

        spline_order = str2double(spline_order_string{k});

        % determine point indices of the part of contour to be smoothed
        inds = gridZoning.(struct_string{k});

        % extract part of contour for smoothing
        xy_part = contours.(specify_string_cont{k})(1:2, inds(1)+1:inds(2));
        numberOfPointsTmp = size(xy_part, 2); % i.e. approx. 28 for tongue

%         xy_sparse = curvspace(xy_part', round(numberOfPointsTmp/2))';
%         numberOfPointsSparseTmp = size(xy_sparse, 2); % i.e. 14 for tongue

        knotsTmp = linspace(0, 1, numberOfPointsTmp-spline_order+2);
		y = linspace(0, 1, 4*numberOfPointsTmp);
        
        xy_smooth = deboor_tuned(knotsTmp, xy_part', y, spline_order)';
        
        xy_smooth_part = xy_smooth; %curvspace(xy_smooth', numberOfPointsTmp)';

        % get the points back to the grid
        indGrdLinesPart = inds(1)+2:inds(2)-1;
        nGrdLines = length(indGrdLinesPart);
        for j = 1:nGrdLines
                        
            nbGrdLine = indGrdLinesPart(j);
            % search the intersect. point of the j-th grdline with contour
            p1 = grd.innerPt(1:2, nbGrdLine);
            p2 = grd.outerPt(1:2, nbGrdLine);

            stillNoIntersection = true;
            cnt = 1;
            while stillNoIntersection
                
                q1 = xy_smooth_part(1:2, cnt);
                q2 = xy_smooth_part(1:2, cnt+1);

                [flag, r] = segments_int_2d(p1', p2', q1', q2');

                if flag
                    stillNoIntersection = false;
                    filteredContours.(specify_string_cont{k})(1:2, nbGrdLine) = r;
                end
                
                cnt = cnt + 1;
            end
            
        end
    end

end
