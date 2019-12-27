function [] = save_to_XML( obj, fileName )
% write content of the model into a XML-file
    %    
    %input arguments:
    %
    %   - fileName  : String, including full path information 

    speakerData.speakerName = obj.speakerName;
    
    if ~isempty(obj.xyStyloidProcess)
        speakerData.landmarks.StyloidProcess = obj.xyStyloidProcess;
    else
        speakerData.landmarks.StyloidProcess = [NaN; NaN];
    end
    
    if ~isempty(obj.xyTongInsL)
        speakerData.landmarks.TongInsL = obj.xyTongInsL;
    else
        speakerData.landmarks.TongInsL = [NaN; NaN];
    end
    
    if ~isempty(obj.xyTongInsH)
        speakerData.landmarks.TongInsH = obj.xyTongInsH;
    else
        speakerData.landmarks.TongInsH = [NaN; NaN];
    end
    
    if ~isempty(obj.xyANS)
        speakerData.landmarks.ANS = obj.xyANS;
    else
        speakerData.landmarks.ANS = [NaN; NaN];
    end
    
    if ~isempty(obj.xyPNS)
        speakerData.landmarks.PNS = obj.xyPNS;
    else
        speakerData.landmarks.PNS = [NaN; NaN];
    end

    if ~isempty(obj.xyVallSin)
        speakerData.landmarks.VallSin = obj.xyVallSin;
    else
        speakerData.landmarks.VallSin = [NaN; NaN];
    end
    
    if ~isempty(obj.xyAlvRidge)
        speakerData.landmarks.AlvRidge = obj.xyAlvRidge;
    else
        speakerData.landmarks.AlvRidge = [NaN; NaN];
    end
    
    if ~isempty(obj.xyPharH)
        speakerData.landmarks.PharH = obj.xyPharH;
    else
        speakerData.landmarks.PharH = [NaN; NaN];
    end

    if ~isempty(obj.xyPharL)
        speakerData.landmarks.PharL = obj.xyPharL;
    else
        speakerData.landmarks.PharL = [NaN; NaN];
    end
    
    if ~isempty(obj.xyPalate)
        speakerData.landmarks.Palate = obj.xyPalate;
    else
        speakerData.landmarks.Palate = [NaN; NaN];
    end
    
    if ~isempty(obj.xyLx)
        speakerData.landmarks.Lx = obj.xyLx;
    else
        speakerData.landmarks.Lx = [NaN; NaN];
    end
    
    if ~isempty(obj.xyLipU)
        speakerData.landmarks.LipU = obj.xyLipU;
    else
        speakerData.landmarks.LipU = [NaN; NaN];
    end
    
    if ~isempty(obj.xyLipL)
        speakerData.landmarks.LipL = obj.xyLipL;
    else
        speakerData.landmarks.LipL = [NaN; NaN];
    end

    if ~isempty(obj.xyTongTip)
        speakerData.landmarks.TongTip = obj.xyTongTip;
    else
        speakerData.landmarks.TongTip = [NaN; NaN];
    end
    
    if ~isempty(obj.xyVelum)
        speakerData.landmarks.Velum = obj.xyVelum;
    else
        speakerData.landmarks.Velum = [NaN; NaN];
    end

    if sum(isnan(obj.xyInnerTrace_raw)) == 0
        speakerData.contours_raw.innerPt = obj.xyInnerTrace_raw;
    else
        speakerData.contours_raw.innerPt = [NaN; NaN];
    end
    
    if sum(isnan(obj.xyOuterTrace_raw)) == 0
        speakerData.contours_raw.outerPt = obj.xyOuterTrace_raw;
    else
        speakerData.contours_raw.outerPt = [NaN; NaN];
    end

    xml_write(fileName, speakerData);

end

