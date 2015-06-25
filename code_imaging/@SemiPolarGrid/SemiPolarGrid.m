classdef SemiPolarGrid
    % calulates speaker-specific grid based on segmented points (see below)
    % this grid is fitted based on four landmarks manually labeled, 
    % namely p_AlvRidge, p_Palate, p_PharH_d, and p_PharL_d
    %
    
    properties
        
        distGridlines = 3; % in lower pharynx and anterior oral cavity
        angleGridlines = 5; % in the upper phynx/ posterior oral cavity

        % gridlines have overlength in order to intersect the contour
        gridlineOverlength = 15;
        
        % the grid
        innerPt = [];
        outerPt = [];
        nGridlines = [];
        
    end
    
    methods
        
%         function obj = SemiPolarGrid()
%             % constructor creates the semi-polar grid
% 
%         end
        
        obj = calculateGrid( obj, struc )
        [] = plot(obj, col, grdLines, cAxes)
        
    end
    
end

