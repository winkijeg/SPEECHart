function matModelTarget = convertToRawModelFormat(obj)
% convert relevant landmarks and structures into model structure

matModelTarget.landmarks = exportLandmarksToModelFormat(obj);
matModelTarget.structures = exportStructuresToModelFormat(obj);

end
