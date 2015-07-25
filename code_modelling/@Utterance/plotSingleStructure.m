function h = plotSingleStructure(obj, structName, nbFrame, colorStr, h_axes)
    %plot single nonrigid structure for a given frame
    %   nonrigid structures are
    %   - larynxArytenoid
    %   - tongueLarynx
    %   - lowerIncisor
    %   - lowerLip

    posX = obj.structures.(structName)(nbFrame, 1:2:end);
    posY = obj.structures.(structName)(nbFrame, 2:2:end);
    
    h = plot(h_axes, posX, posY, colorStr);
    
end

