function [] = drawMesh(obj, col)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    for k = 1:obj.nNodes
        
        plot(obj.positionNodes(k).positionX, ...
        obj.positionNodes(k).positionY, [col '.'])
        hold on
       
    end       

end

