function h = drawMuscleNodes(obj, muscle, colStr)
    %draw muscle node within one frame

    nFibers = muscle.nFibers;

    indicesMuscleNodes = [muscle.fiberFixpoints{1:nFibers,:}];
    
    xPos = obj.xValNodes(indicesMuscleNodes);
    yPos = obj.yValNodes(indicesMuscleNodes);
            
    h = plot(xPos, yPos, [colStr 'o'], 'MarkerSize', 3);
    
end
