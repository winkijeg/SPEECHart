function [] = export_to_XML( obj, fileName )
% write content of the model into a XML-file
    %    
    %input arguments:
    %
    %   - fileName  : String, including full path information 

    speakerData.speakerName = obj.speakerName;
    speakerData.landmarks.StyloidProcess = obj.xyStyloidProcess;
    speakerData.landmarks.TongInsL = obj.xyTongInsL;
    speakerData.landmarks.TongInsH = obj.xyTongInsH;
    speakerData.landmarks.ANS = obj.xyANS;
    speakerData.landmarks.PNS = obj.xyPNS;
    speakerData.landmarks.VallSin = obj.xyVallSin;
    speakerData.landmarks.AlvRidge = obj.xyAlvRidge;
    speakerData.landmarks.PharH = obj.xyPharH;
    speakerData.landmarks.PharL = obj.xyPharL;
    speakerData.landmarks.Palate = obj.xyPalate;
    speakerData.landmarks.Lx = obj.xyLx;
    speakerData.landmarks.LipU = obj.xyLipU;
    speakerData.landmarks.LipL = obj.xyLipL;
    speakerData.landmarks.TongTip = obj.xyTongTip;
    speakerData.landmarks.Velum = obj.xyVelum;
    
    speakerData.contours.innerPt = obj.xyInnerTrace;
    speakerData.contours.outerPt = obj.xyOuterTrace;

    xml_write(fileName, speakerData);

end

