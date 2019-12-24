function [] = plot_contour_sampled(obj, col, h_axes)
% plot the two traces which were manually determined
    % this method plots contour only if the positions are non-empty
    %    
    %input arguments:
    %
    %   - col       : color, i.e. 'r' for red, or [1 0 0] ( RGB - triple )
    %   - h_axes    : axes handle of the window to be plotted to
    %
 
  
    xVals_inner_tmp = obj.xyInnerTrace_sampl(1, :);
    yVals_inner_tmp = obj.xyInnerTrace_sampl(2, :);

    xVals_outer_tmp = obj.xyOuterTrace_sampl(1, :);
    yVals_outer_tmp = obj.xyOuterTrace_sampl(2, :);
 
    plot(h_axes, xVals_inner_tmp, yVals_inner_tmp, ...
            'Color', col , 'Tag', 'cont_sampl', 'LineWidth', 3);
    plot(h_axes, xVals_outer_tmp, yVals_outer_tmp, ...
            'Color', col , 'Tag', 'cont_sampl', 'LineWidth', 3);        
    
end
