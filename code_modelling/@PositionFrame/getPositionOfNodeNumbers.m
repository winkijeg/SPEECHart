function points = getPositionOfNodeNumbers(obj, nodeNumbers)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

    xVals = [obj.positionNodes.positionX];
    yVals = [obj.positionNodes.positionY];
    
    points = [xVals(1, nodeNumbers); yVals(1, nodeNumbers)];

end
