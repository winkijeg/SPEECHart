classdef PositionFrame
    % represents position of all nodes at a (given) time 
    %   Detailed explanation goes here
    
    properties
        
        timeOfFrame = NaN;
        nNodes = 221;
        positionNodes = PositionNode;
        
    end
    
        
        
    
    methods
        
        function obj = PositionFrame(timeOfFrame, xVals, yVals)
            
            if nargin ~= 0
            
                obj.timeOfFrame = timeOfFrame;
                obj.positionNodes(obj.nNodes) = PositionNode; % memory allocation
            
                for k = 1:obj.nNodes
                    obj.positionNodes(k) = PositionNode(xVals(k), yVals(k));
                end
                
            end
            
        end
        
        % method declarations .............................................
        
        [] = drawMesh(obj, col);
        [] = drawNodeNumbers(obj);
        [] = drawTongSurface(obj, col);
        [] = drawMuscleNodes(obj, muscle);
        
        pts = getPositionOfNodeNumbers(obj, nodeNumbers);
        pts = getPositionOfTongSurface(obj);
         
    end
    
end
