function h = drawTongSurface(obj, col)
%plot tongue surface corresponding to one frame


    indicesSurfaceNodes = [13 26 39 52 65 78 91 104 117 130 143 ...
        156 169 182 195 208 221 220 219 218 217 216 215 214 213 ...
        212 211 210 209];
            
        xPos = obj.xValNodes(1, indicesSurfaceNodes);
        yPos = obj.yValNodes(1, indicesSurfaceNodes);

        h = plot(xPos, yPos, col);
end
