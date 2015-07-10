function h = drawMesh(obj, col)
    %draw complete tongue mesh 
    
    h = plot(obj.xValNodes, obj.yValNodes, [col '.']);

end
