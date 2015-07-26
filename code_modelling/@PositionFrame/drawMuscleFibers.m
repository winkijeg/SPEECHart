function h = drawMuscleFibers(obj, muscle, colStr, h_axes)
    %draw muscle node within one frame

    muscleName = muscle.nameShort;
    
    switch muscleName
        case 'VER'
            
            nFibers = muscle.nFibers;

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
