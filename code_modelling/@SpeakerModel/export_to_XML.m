function [] = export_to_XML( obj, fileName )
% write content of the model into a XML-file

    modelData.modelName = obj.modelName;
    modelData.modelUUID = obj.modelUUID;
    
    modelData.nMeshFibers = obj.nMeshFibers;
    modelData.nSamplePointsPerMeshFiber = obj.nSamplePointsPerMeshFiber;
    
    modelData.landmarks = obj.landmarks;
    modelData.structures = obj.structures;
    
    % convert PositionFrame into struct
    modelData.tongue.xVal = obj.tongue.xValNodes;
    modelData.tongue.yVal = obj.tongue.yValNodes;

    xml_write(fileName, modelData);

end

