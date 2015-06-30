function [] = disp( obj )
% class-specific disp - implementation

    disp([sprintf('\n') 'speaker ' obj.speakerName]);
    disp('....................................');
    
    propsTmp = properties(SpeakerData);
    
    for nbProp = 1:length(propsTmp)
        
        propTmp = propsTmp{nbProp, :};
        valTmp = obj.(propsTmp{nbProp});
        nPoints = size(valTmp, 2);
    
        classTmp = class(valTmp);
        
        switch classTmp
            
            case 'char'
                strTmp = sprintf('%s = %s', propTmp, valTmp);
                disp(strTmp)
                
            
            case 'SemiPolarGrid'
                 strTmp = sprintf('%s  = [%s]', propTmp, class(valTmp));
                 disp(strTmp)
                
            case 'double'

                if (nPoints == 0)
                    strTmp = sprintf('%s  = []', propTmp);
                    disp(strTmp)
                end
                
                if (nPoints == 1)
                    strTmp = sprintf('%s  = [%.2f %.2f]', propTmp, valTmp(1), valTmp(2));
                    disp(strTmp)
                end
                
                if (nPoints > 1)
                    strTmp = sprintf('%s  = %.0f points', propTmp, nPoints);
                    disp(strTmp)
                end
            case 'struct'
                disp(valTmp)
        
        end
        
    end
    
    str1 = sprintf('....................................\n');
    disp(str1)

end
