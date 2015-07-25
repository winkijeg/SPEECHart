function h_surface = drawTongSurface(obj, col, h_axes)
%plot tongue surface for one PositionFrame

    if ~exist('col', 'var') || isempty(col)
        col = 'k';
    end

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = gca;
    end


    indicesSurfaceNodes = [13 26 39 52 65 78 91 104 117 130 143 ...
        156 169 182 195 208 221 220 219 218 217 216 215 214 213 ...
        212 211 210 209];
            
        xPos = obj.xValNodes(1, indicesSurfaceNodes);
        yPos = obj.yValNodes(1, indicesSurfaceNodes);

        h_surface = plot(h_axes, xPos, yPos, col);
end
