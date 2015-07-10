function h = plotSingleStructure(obj, structName, targetFrame, colorStr)
    %plot single nonrigid structure for a given frame
    %   nonrigid structures are
    %   - larynxArytenoid
    %   - tongueLarynx
    %   - lowerIncisor
    %   - lowerLip

    targetStrX = [structName 'PosX'];
    targetStrY = [structName 'PosY'];

    posX = obj.(targetStrX)(targetFrame, :);
    posY = obj.(targetStrY)(targetFrame, :);
    
    h = plot(posX, posY, colorStr);
    
end

