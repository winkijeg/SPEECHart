function contours = calcContoursFromSegmentation(obj)

    nSamplePointsProfile = 200;

    % test for availability of image progessing toolbox
    hasToolbox = ~isempty(ver('images'));

    if ~hasToolbox
        error('missing toolbox (Image Progessing Toolbox)');
    end

    % -----------------------------------------------------------------------
    
    numberOfGridlines = obj.semipolarGrid.numberOfGridlines;
        
    ptIntersectInnerContSeg = ones(2, numberOfGridlines) * NaN;
    ptIntersectOuterContSeg = ones(2, numberOfGridlines) * NaN;

    for nbGrdLine = 1:numberOfGridlines

        ptProfileInner = [obj.semipolarGrid.innerPt(1, nbGrdLine) ...
            obj.semipolarGrid.innerPt(2, nbGrdLine)];
        ptProfileOuter = [obj.semipolarGrid.outerPt(1, nbGrdLine) ...
            obj.semipolarGrid.outerPt(2, nbGrdLine)];

        [cx, cy, c] = improfile(obj.xdataSlice, obj.ydataSlice, ...
            obj.sliceSegmentationData, [ptProfileInner(1) ptProfileOuter(1)], ...
            [ptProfileInner(2) ptProfileOuter(2)], nSamplePointsProfile);

        % remove NaNs
        c = c(~isnan(c));
        cx = cx(~isnan(c));
        cy = cy(~isnan(c));

        if ~isempty(find(c, 1))

            if c(1) == 1
                
                ptIntersectInnerContSeg(1:2, nbGrdLine) = [NaN NaN];
                ptIntersectOuterTmp(1:2) = ...
                    [cx(find(c, 1, 'last')) cy(find(c, 1, 'last'))];
                % ensure that contour point lies on the grid line
                ptIntersectOuterContSeg(1:2, nbGrdLine) = ...
                    line_exp_point_near_2d(ptProfileInner, ptProfileOuter, ...
                    ptIntersectOuterTmp);

            else
                
                ptIntersectOuterTmp(1:2) = ...
                    [cx(find(c, 1, 'last')) cy(find(c, 1, 'last'))];
                ptIntersectInnerTmp(1:2) = ...
                    [cx(find(c, 1, 'first')) cy(find(c, 1, 'first'))];

                % ensure that contour point lies on the grid line
                ptIntersectOuterContSeg(1:2, nbGrdLine) = ...
                    line_exp_point_near_2d(ptProfileInner, ptProfileOuter, ...
                    ptIntersectOuterTmp);
                ptIntersectInnerContSeg(1:2, nbGrdLine) = ...
                    line_exp_point_near_2d(ptProfileInner, ptProfileOuter, ...
                    ptIntersectInnerTmp);

            end
            
        else
            ptIntersectInnerContSeg(1:2, nbGrdLine) = [NaN NaN];
            ptIntersectOuterContSeg(1:2, nbGrdLine) = [NaN NaN];
        end
        clear cx cy c;
    end

    % find gridlines that DO NOT intersect with the segmentation
    indicesInnerPointValid = ~isnan(ptIntersectInnerContSeg(2, :));
    indicesOuterPointValid = ~isnan(ptIntersectOuterContSeg(2, :));
    
    % remove lines with NaN
    contours.innerPt = ptIntersectInnerContSeg(1:2, indicesInnerPointValid);
    contours.outerPt = ptIntersectOuterContSeg(1:2, indicesOuterPointValid);

end
