function landmarks = exportLandmarksToModelFormat(obj)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    landmarks.styloidProcess = obj.landmarks.Stylo;
    
    % the three hyoid points will be transformed (later)
    landmarks.condyle = [obj.landmarks.Stylo(1); obj.landmarks.Stylo(2)+8];
    landmarks.tongInsL = obj.landmarks.TongInsL;
    landmarks.tongInsH = obj.landmarks.TongInsH;
    
    from = obj.gridZoning.tongue(1);
    to = obj.gridZoning.tongue(2);
    tongSurfTmp = obj.filteredContours.innerPt(1:2, from:to);
    
    landmarks.origin = mean(tongSurfTmp, 2);
    

end
