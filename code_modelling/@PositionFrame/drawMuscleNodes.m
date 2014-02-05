function [] = drawMuscleNodes(obj, muscle)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    indicesMuscleNodes = muscle.fiberNodeNumbers;
    xPos = [obj.positionNodes(indicesMuscleNodes).positionX];
    yPos = [obj.positionNodes(indicesMuscleNodes).positionY];
            
    plot(xPos, yPos, 'o', 'MarkerSize', 3);
    
end
