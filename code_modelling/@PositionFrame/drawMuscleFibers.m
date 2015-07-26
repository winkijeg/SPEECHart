function h = drawMuscleFibers(obj, muscle, colStr, h_axes)
    %draw muscle node within one frame
    
    isExternalMuscle = ~(isempty(muscle.externalInsertionPointPosition));
    nFibers = muscle.nFibers;
    
    if(isExternalMuscle)

        for nbFiber = 1:nFibers

            nNodeNumberOfFiber = size(muscle.fiberFixpoints(nbFiber, :), 2);

            pt = ones(2, nNodeNumberOfFiber);
            for nbFiberPoint = 1:nNodeNumberOfFiber

                typeStr = class(muscle.fiberFixpoints{nbFiber, nbFiberPoint});

                switch typeStr

                    case 'char'

                        pt(1:2, nbFiberPoint) = ...
                            muscle.externalInsertionPointPosition.(muscle.fiberFixpoints{nbFiber, nbFiberPoint});

                    case 'double'

                        nodeNumberTmp = muscle.fiberFixpoints{nbFiber, nbFiberPoint};
                        if ~(isempty(nodeNumberTmp))
                            pt(1:2, nbFiberPoint) = obj.getPositionOfNodeNumbers(nodeNumberTmp);
                        else
                            pt(1:2, nbFiberPoint) = [NaN; NaN];
                        end

                end
            end

            h = plot(h_axes, pt(1,:), pt(2,:), ['-' colStr '.']);
            clear pt

        end
                
    
    else
        
            for nbFiber = 1:nFibers
                
                nodeNumbersOfFiber = [muscle.fiberFixpoints{nbFiber, :}];
                nNodeNumberOfFiber = size([muscle.fiberFixpoints{nbFiber, :}], 2);
                
                xValsTmp = obj.xValNodes(nodeNumbersOfFiber);
                yValsTmp = obj.yValNodes(nodeNumbersOfFiber);
                
                % plot fibers (with dots at the fiber nodes)
                h = plot(h_axes, xValsTmp, yValsTmp, ['-' colStr '.']);
                
                % plot mesh elements affected by the change in stiffness
                
                if (nbFiber ~= nFibers)
                    for nbNode = 1:nNodeNumberOfFiber-1
                    
                        nodeNumber1 = nodeNumbersOfFiber(nbNode);
                        nodeNumber2 = nodeNumber1 + 13 + 1;
                    
                        pt1 = obj.getPositionOfNodeNumbers(nodeNumber1);
                        pt2 = obj.getPositionOfNodeNumbers(nodeNumber2);
                    
                        plot([pt1(1) pt2(1)], [pt1(2) pt2(2)], 'Color', [0.7 0.7 0.7]);
                    
                    end
                end
 
                if (nbFiber ~= 1)
                    for nbNode = 1:nNodeNumberOfFiber-1
                    
                        nodeNumber1 = nodeNumbersOfFiber(nbNode);
                        nodeNumber2 = nodeNumber1 - 13 + 1;
                    
                        pt1 = obj.getPositionOfNodeNumbers(nodeNumber1);
                        pt2 = obj.getPositionOfNodeNumbers(nodeNumber2);
                    
                        plot([pt1(1) pt2(1)], [pt1(2) pt2(2)], 'Color', [0.7 0.7 0.7]);
                    
                    end
                    
                    
                end
   
                
            end
    
    end
    
end

