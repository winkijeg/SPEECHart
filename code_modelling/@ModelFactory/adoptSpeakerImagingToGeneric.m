function obj = adoptSpeakerImagingToGeneric(obj, spkImaging)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    
    % export relevant landmarks into FEM structure
    obj.matSource.landmarks = exportLandmarksToModelFormat(spkImaging);
    % export relevant structures into FEM structure
    obj.matSource.structures = exportStructuresToModelFormat(spkImaging);
    
    
end

