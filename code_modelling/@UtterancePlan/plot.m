function [] = plot(obj, featureString, plotStr)
%plot utterance plan specification

    nTargets = size(obj.target, 2);
    
    yValsTmp = obj.(featureString);
    
    
    % loop through targets
    for nbTarget = 1:nTargets
        
        labTmp = obj.target(nbTarget)
        durTmp(nbTarget) = (obj.durTransition(nbTarget) + ...
            obj.durHold(nbTarget)) * 1000
        durSum = sum(durTmp(1:nbTarget-1))
            
        % first segment ist special case
        if nbTarget == 1
            
            x1 = 0;
            y1 = 0;
            
            x2 = durTmp(nbTarget);
            y2 = yValsTmp(nbTarget);
            
            
        else
            
            x1 = durSum;
            y1 = yValsTmp(nbTarget-1);
            
            x2 = durSum + durTmp(nbTarget);
            y2 = yValsTmp(nbTarget);
        
        end
        
        mArrow3([x1 y1 0], [x2 y2 0]);
        %plot([x1 x2], [y1 y2]);
        hold on;
    end

end

