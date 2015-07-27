function obj = set_condylePoint(obj, xPos, yPos)
%move condyle to an arbitrary position (use only if you know what you do!)
    
    obj.landmarks.styloidProcess = [xPos; yPos];
    obj.landmarks.condyle = [xPos; yPos+8];

end

