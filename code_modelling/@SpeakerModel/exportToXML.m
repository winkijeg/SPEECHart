function [] = exportToXML( obj, fileName )
% write content of the model into a XML-file

    modelData.landmarks = obj.landmarks;
    modelData.structures = obj.structures;
    
    % convert PositionFrame into struct
    modelData.tongGrid.xVal = [obj.tongGrid.positionNodes(:).positionX];
    modelData.tongGrid.yVal = [obj.tongGrid.positionNodes(:).positionY];

    xml_write(fileName, modelData);

end

