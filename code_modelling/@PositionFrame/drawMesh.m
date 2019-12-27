function h = drawMesh(obj, col, h_axes)
%draw complete tongue mesh
    
    if ~exist('col', 'var') || isempty(col)
        col = 'k';
    end

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = gca;
    end
    
    X0 = reshape(obj.xValNodes, 13, 17)';
    Y0 = reshape(obj.yValNodes, 13, 17)';
    
    axes(h_axes);
    h = mesh(X0,Y0, zeros(size(X0)), 'EdgeColor', col);

end
