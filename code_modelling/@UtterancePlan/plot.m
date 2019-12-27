function [] = plot(obj, featureString, plotStr)
%plot muscle activation pattern over time
    %    
    %input arguments:
    %
    %   - featureString     : String, i.e. 'GGA'
    %                         possible values are: 
    %                           o 'deltaLambdaGGP',
    %                           o 'deltaLambdaGGA',
    %                           o 'deltaLambdaHYO',
    %                           o 'deltaLambdaSTY',
    %                           o 'deltaLambdaVER',
    %                           o 'deltaLambdaSL',
    %                           o 'deltaLambdaIL',
    %                           o 'jawRotation',
    %                           o 'lipProtrusion',
    %                           o 'lipRotation',
    %                           o 'hyoid_mov'
    % 
    %   - plotStr           : color, i.e. ''

    yValMax = 20;
    yValMin = -20;
    labWinHight = 3;

    nTargets = size(obj.target, 2);
    
    featureVals = obj.(featureString);
    
    figure
    hold on
    
    preceedingVal = 0;
    % loop through targets
    for nbTarget = 1:nTargets
        
        labTarget{nbTarget} = obj.target(nbTarget);
        durTarget = obj.durTransition(nbTarget) + ...
            obj.durHold(nbTarget);
        
        if (nbTarget == 1)
            t1(nbTarget) = 0;
        else
            t1(nbTarget) = t2(nbTarget-1);
        end
        t2(nbTarget) = t1(nbTarget) + durTarget;

        % draw decoration 
        rectangle('Position', [t1(nbTarget) yValMax+2 durTarget labWinHight], ...
            'Curvature', 0.4, 'LineWidth', 1, 'LineStyle','-')
        
        midTarget = t1(nbTarget) + (durTarget/2);
        text(midTarget, yValMax+(labWinHight/2)+2, labTarget{nbTarget});

        % draw feature track
        ta = t1(nbTarget);
        tb = ta + obj.durTransition(nbTarget);
        tc = tb + obj.durHold(nbTarget);
        
        taVal = preceedingVal;
        tbVal = featureVals(nbTarget);
        tcVal = tbVal;
        
        %tLab2Val = yValsTmp(nbTarget)
        
        plot([ta tb], [taVal tbVal], plotStr);
        plot([tb tc], [tbVal tcVal], plotStr);
        
        preceedingVal = tcVal;
        
    end
    
   
    axis([0 t2(end) yValMin-2 yValMax+labWinHight+2])
    grid on
    xlabel('time [sec]')
    ylabel([featureString ' [\Delta\lambda]'])
    
end

