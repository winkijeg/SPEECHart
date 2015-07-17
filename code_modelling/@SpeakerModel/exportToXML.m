function [] = exportToXML( obj, fileName )
% write content of the model into a XML-file

    modelData.modelName = obj.modelName;
    modelData.modelUUID = obj.modelUUID;
    
    modelData.landmarks = obj.landmarks;
    modelData.structures = obj.structures;
    
    % convert PositionFrame into struct
    modelData.tongGrid.xVal = obj.tongGrid.xValNodes;
    modelData.tongGrid.yVal = obj.tongGrid.yValNodes;

    xml_write(fileName, modelData);

end

