function [] = drawNodeNumbers(obj)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    for k = 1:obj.nNodes

        text(obj.positionNodes(k).positionX, ...
            obj.positionNodes(k).positionY, num2str(k))

    end

end

