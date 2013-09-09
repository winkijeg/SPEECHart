function pts = getPositionOfTongSurface(obj)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    indicesSurfaceNodes = [13 26 39 52 65 78 91 104 117 130 143 ...
        156 169 182 195 208 221];
    
            
        xPos = [obj.positionNodes(indicesSurfaceNodes).positionX];
        yPos = [obj.positionNodes(indicesSurfaceNodes).positionY];
        
        pts(1:2, :) = [xPos; yPos];
        
end