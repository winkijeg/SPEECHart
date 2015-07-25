function h_mesh = plot_tongueMesh( obj, col, h_axes )
%plot tongue mesh (finite elements) - tongue rest position of the VT model

    if ~exist('col', 'var') || isempty(col)
        col = 'k';
    end

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = obj.initPlotFigure(false);
    end


    h_mesh = obj.tongue.drawMesh(col, h_axes);

    
end

