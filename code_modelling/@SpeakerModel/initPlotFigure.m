function h_axes = initPlotFigure(obj, imgFlag)
% create figure with axes labels / limits according to the specific model
    %    
    %input arguments:
    %
    %   - imgFlag   : flag to incorporate the MRI into the plot figure
    %                   (to be implemented in the near future ...)
    %                   so far the only value is false (no picture)
    %

    % range of x and y values seen in the new pic
    xDim = 165; % [mm]
    yDim = xDim; % [mm]

    
    ptCenter = obj.landmarks.xyOrigin;
    xlim = [ptCenter(1) - xDim/2 ptCenter(1) + xDim/2];
    ylim = [ptCenter(2) - yDim/2 ptCenter(2) + yDim/2];
    
    if (imgFlag)
   
        % to be implemented ...
        
    else
         figure;
         h_axes = gca;
    end
    
    axis on;
    axis equal; 
    hold on;
    
    % adjust the visible part ----------------------------------------
    set(gca, 'XLim', xlim, 'YLim', ylim);

    % label the axes -------------------------------------------------
    xlabel ('A -> P [mm]');
    ylabel ('I -> S [mm]');
   
end
