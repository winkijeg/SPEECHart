function pts = getPositionOfTongSurface(obj)
% return positions of tongue surface at a given time frame (PositionFrame)

    indicesSurfaceNodes = [13 26 39 52 65 78 91 104 117 130 143 ...
        156 169 182 195 208 221];
    
            
        xPos = obj.xValNodes(indicesSurfaceNodes);
        yPos = obj.yValNodes(indicesSurfaceNodes);
        
        pts(1:2, :) = [xPos; yPos];
        
end
