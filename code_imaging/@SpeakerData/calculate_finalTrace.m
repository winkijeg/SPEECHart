function xyOut = calculate_finalTrace( obj, xyIn )
%calculate final trace based on the semi-polar grid
    %    
    %input arguments:
    %
    %   - xyIn       : values dtermined by creating a trace manually
    %

    myTrace = complex(xyIn(1,:), xyIn(2,:));
    
    nGrdLines = obj.grid.nGridlines;
    xyOut = ones(2, nGrdLines) * NaN;
    
    for nbGrdLine = 1:nGrdLines
        
        xyValsGrdLine = [obj.grid.innerPt(1:2, nbGrdLine) obj.grid.outerPt(1:2, nbGrdLine)];
        myGrdLine = complex(xyValsGrdLine(1,:), xyValsGrdLine(2,:));

        resultTmp = crossings(myTrace, myGrdLine);
        
        if any(resultTmp)
            zi = interp1(1:length(myTrace), myTrace, resultTmp(resultTmp ~= 0));
            %plot(real(zi), imag(zi), 'bo')
            xyOut(1:2, nbGrdLine) = [real(zi); imag(zi)];
            
        end
        clear resultTmp
            
    end
    
end

