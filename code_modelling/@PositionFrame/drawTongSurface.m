function [] = drawTongSurface(obj, col)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    indicesSurfaceNodes = [13 26 39 52 65 78 91 104 117 130 143 ...
        156 169 182 195 208 221 220 219 218 217 216 215 214 213 ...
        212 211 210 209];
            
        xPos = [obj.positionNodes(indicesSurfaceNodes).positionX];
        yPos = [obj.positionNodes(indicesSurfaceNodes).positionY];
            
        h = plot(xPos, yPos, col);
        
end
