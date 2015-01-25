function obj = setCondylePoint(obj, xPos, yPos)
%UNTITLED3 Summary of this function goes here
    %   Detailed explanation goes here
    
    obj.landmarks.styloidProcess = [xPos; yPos];
    obj.landmarks.condyle = [xPos; yPos+8];

end

