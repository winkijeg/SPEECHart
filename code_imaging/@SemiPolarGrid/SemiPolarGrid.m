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
        
    end
    
end

