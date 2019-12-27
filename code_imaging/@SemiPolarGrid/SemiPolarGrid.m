classdef SemiPolarGrid
% speaker-specific semi-polar grid based on segmented points (see below)
    % this grid is fitted based on four manually labeled landmarks, 
    %
    %   - AlvRidge
    %   - Palate
    %   - PharH_d
    %   - PharL_d
    
    properties
        
        innerPt@double      % left / inferior point(s) of each gridline
        outerPt@double      % right / superior point(s) of each gridline
        nGridlines@double   % number of gridlines
        
        labeledPoints = struct('Lx', [], 'Palate', [], 'AlvRidge', [], ...
            'LipU', [], 'LipL', [], 'PharL', [], 'PharH', [], ...
            'ANS', [], 'PNS' , [])
        
        derivedPoints = struct('H1', [], ...    % circle midpoint
            'H2', [], ...   % defines end of part 2 of the grid 
            'H3', [], ...   % left boundary of very first gridline
            'H4', [], ...   % right boundary of very first gridline (+overLength)
            'H5', [])       % rotation center of the 5th part of the grid
        
        grdLineLabel@double % assign label for grid part
        
    end
    
    properties (Constant)
        
        distGridlines = 3   % in lower pharynx and anterior oral cavity
        angleGridlines = 5  % in the upper phynx / posterior oral cavity

        % gridlines have overlength in order to always intersect the contour
        gridlineOverlength = 15;

    end
    
    
    methods

        obj = calculateGrid( obj, struc )
        [] = plot(obj, col, grdLines, cAxes)
        [] = plot_landmarks(obj, col, h_axes)
        [] = plot_landmarks_derived(obj, col, h_axes);
        
    end
    
end

