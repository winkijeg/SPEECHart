function matModelTarget = convertToRawModelFormat(obj)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    % export relevant landmarks/structures into FEM structure
    matModelTarget.landmarks = exportLandmarksToModelFormat(obj);
    matModelTarget.structures = exportStructuresToModelFormat(obj);

end

