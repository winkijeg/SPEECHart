function [] = plotSingleStructure(obj, structName, targetFrame, colorStr)
%plot single structures at a given time point

    targetStrX = [structName 'PosX'];
    targetStrY = [structName 'PosY'];

    posX = obj.(targetStrX)(targetFrame, :);
    posY = obj.(targetStrY)(targetFrame, :);
    
    plot(posX, posY, colorStr)
    
end

